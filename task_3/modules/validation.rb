# frozen_string_literal: true

module Validation
  ERRORS = {
      blank: '%s is nil or empty!',
      format: '%s does not match the pattern!',
      type: '%s - incorrect class type!'
  }.freeze

  def self.included(base)
    base.extend ClassMethods
    base.include InstanceMethods
  end

  module ClassMethods
    def validate(name, type, param = nil)
      @validations ||= []
      @validations << {name: name, type: type, param: param}
    end
  end

  module InstanceMethods
    def valid?
      validate!
      true
    rescue RuntimeError => e
      puts e.message
      false
    end

    protected

    def validate!
      errors =
          self.class.instance_variable_get('@validations'.to_sym).each_with_object([]) do |opts, errors|
            value = instance_variable_get("@#{opts[:name]}".to_sym)
            errors << send("#{opts[:type]}_validate".to_sym, opts.merge(value: value))
          end.compact
      raise errors.join("\n") unless errors.empty?
    end
  end

  protected

  def presence_validate(opts)
    ERRORS[:blank] % opts[:name] if opts[:value].nil? || opts[:value].to_s.strip.empty?
  end

  def format_validate(opts)
    ERRORS[:format] % opts[:name] if opts[:value] !~ opts[:param]
  end

  def type_validate(opts)
    ERRORS[:type] % opts[:value].class unless opts[:value].is_a? opts[:param]
  end
end
