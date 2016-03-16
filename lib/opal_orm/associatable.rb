require_relative 'searchable'
require 'active_support/inflector'

class AssocOptions
  attr_accessor(
    :foreign_key,
    :class_name,
    :primary_key
  )

  def model_class
    class_name.constantize
  end

  def table_name
    class_name.underscore + "s"
  end
end

class BelongsToOptions < AssocOptions
  def initialize(name, options = {})
    @foreign_key = options[:foreign_key] || "#{name}_id".to_sym
    @class_name = options[:class_name] || name.to_s.camelcase
    @primary_key = options[:primary_key] || :id
  end
end

class HasManyOptions < AssocOptions
  def initialize(name, self_class_name, options = {})
    @foreign_key = options[:foreign_key] || "#{self_class_name.downcase}_id".to_sym
    @class_name = options[:class_name] || name.to_s.camelcase.singularize
    @primary_key = options[:primary_key] || :id
  end
end

module Associatable
  def belongs_to(name, options = {})
    assoc_options[name] = BelongsToOptions.new(name,options)
    define_method(name) do
      # p "within class"
      # p @assoc_options = BelongsToOptions.new(name,options)
      opts = self.class.assoc_options[name]
      opts.model_class.find(self.send("#{opts.foreign_key}"))
    end
  end


  def has_many(name, options = {})
    define_method(name) do
      @options = HasManyOptions.new(name,self.class.to_s,options)
      cats = @options.model_class.where(@options.foreign_key => id)
    end
  end

  def assoc_options
    @assoc_options ||= {}
  end

  def has_one_through(name, through_name, source_name)
    define_method(name) do
      through_options = self.class.assoc_options[through_name]
      source_options = through_options.model_class.assoc_options[source_name]
      pk = 1
      through =
        through_options.model_class
        .where(through_options.primary_key => id)
        .first

      source_options.model_class.find(through.id)
    end
  end
end

class SQLObject
  extend Associatable
end
