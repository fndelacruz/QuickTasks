require 'active_support/inflector'
require_relative 'associatable_options'

class HasManyOptions < AssociatableOptions
  def initialize(name, self_class_name, options = {})
    name = name.to_s
    @class_name = options[:class_name] || name.singularize.camelcase
    @foreign_key = options[:foreign_key] || "#{self_class_name.underscore}_id".to_sym
    @primary_key = options[:primary_key] || "id".to_sym
  end
end
