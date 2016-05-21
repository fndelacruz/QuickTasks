require 'active_support/inflector'
require_relative 'associatable_options'

class BelongsToOptions < AssociatableOptions
  def initialize(name, options = {})
    name = name.to_s
    @class_name = options[:class_name] || name.camelcase
    @foreign_key = options[:foreign_key] || "#{name}_id".to_sym
    @primary_key = options[:primary_key] || "id".to_sym
  end
end
