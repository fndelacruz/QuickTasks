require_relative 'has_many_options'
require_relative 'belongs_to_options'

module Associatable
  def belongs_to(name, options = {})
    options = BelongsToOptions.new(name, options)
    assoc_options[name] = options

    define_method(name) do
      self_table = self.class.table_name
      other_table = options.table_name
      results = DBConnection.execute(<<-SQL, id)
        SELECT
          #{other_table}.*
        FROM
          #{other_table}
        JOIN
          #{self_table} ON #{other_table}.#{options.primary_key} =
            #{self_table}.#{options.foreign_key}
        WHERE
          #{self_table}.id = ?
      SQL
      case results.length
      when 0
        nil
      when 1
        options.model_class.new(results.first)
      else
        raise "belongs_to found multiple records" if results.length > 1
      end
    end
  end

  def has_many(name, options = {})
    options = HasManyOptions.new(name, self.to_s, options)
    define_method(name) do
      self_table = self.class.table_name
      other_table = options.table_name
      results = DBConnection.execute(<<-SQL, id)
        SELECT
          #{other_table}.*
        FROM
          #{other_table}
        JOIN
          #{self_table} ON #{other_table}.#{options.foreign_key} =
            #{self_table}.#{options.primary_key}
        WHERE
          #{other_table}.#{options.foreign_key} = ?
      SQL
      options.model_class.parse_all(results)
    end
  end

  def has_one_through(name, through_name, source_name)
    define_method(name) do
      t_options = self.class.assoc_options[through_name]
      s_options = t_options.model_class.assoc_options[source_name]
      results = DBConnection.execute(<<-SQL, id)
        SELECT
          #{s_options.table_name}.*
        FROM
          #{self.class.table_name}
        JOIN
          #{t_options.table_name} ON
            #{self.class.table_name}.#{t_options.foreign_key} =
              #{t_options.table_name}.#{t_options.primary_key}
        JOIN
          #{s_options.table_name} ON
            #{t_options.table_name}.#{s_options.foreign_key} =
              #{s_options.table_name}.#{s_options.primary_key}
        WHERE
          #{self.class.table_name}.id = ?
      SQL
      case results.length
      when 0
        nil
      when 1
        s_options.model_class.new(results.first)
      else
        raise "More than one object found on has_one_through"
      end
    end
  end

  def assoc_options
    @assoc_options ||= {}
  end
end
