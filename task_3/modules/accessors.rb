# frozen_string_literal: true

module Accessors
  ERRORS = {
    type: 'Incorrect type class: %s/%s (current/expected)!'
  }.freeze

  def attr_accessor_with_history(*names)
    names.each do |name|
      define_method(name) { instance_variable_get("@#{name}".to_sym) }
      define_method("#{name}_history".to_sym) { instance_variable_get("@#{name}_history".to_sym) }
      implement_history_setter(name)
    end
  end

  def strong_attr_accessor(name, class_type)
    define_method(name) { instance_variable_get("@#{name}".to_sym) }
    implement_type_setter(name, class_type)
  end

  protected

  def implement_history_setter(name)
    define_method("#{name}=".to_sym) do |value|
      var_history = instance_variable_get("@#{name}_history".to_sym)
      instance_variable_set("@#{name}_history".to_sym, []) unless var_history
      prev_value = instance_variable_get("@#{name}".to_sym)
      instance_variable_get("@#{name}_history".to_sym).push(prev_value)
      instance_variable_set("@#{name}".to_sym, value)
    end
  end

  def implement_type_setter(name, class_type)
    define_method("#{name}=".to_sym) do |value|
      raise format(ERRORS[:type], value.class, class_type) unless value.is_a? class_type

      instance_variable_set("@#{name}".to_sym, value)
    end
  end
end
