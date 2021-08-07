# frozen_string_literal: true

module Accessors
  def attr_accessor_with_history(*vars)
    vars.each do |var|
      define_method(var) { instance_variable_get("@#{var}".to_sym) }
      define_method("#{var}_history".to_sym) { instance_variable_get("@#{var}_history".to_sym) }
      implement_setter(var)
    end
  end

  protected

  def implement_setter(var)
    define_method("#{var}=".to_sym) do |value|
      var_history = instance_variable_get("@#{var}_history".to_sym)
      instance_variable_set("@#{var}_history".to_sym, []) unless var_history
      prev_value = instance_variable_get("@#{var}".to_sym)
      instance_variable_get("@#{var}_history".to_sym).push(prev_value)
      instance_variable_set("@#{var}".to_sym, value)
    end
  end
end
