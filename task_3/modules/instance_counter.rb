# frozen_string_literal: true

module InstanceCounter
  def self.included(base)
    class << base
      attr_accessor :all_instances
    end

    base.extend ClassMethods
    # base.send :include, InstanceMethods
    base.include InstanceMethods # used ~> 2.5 ruby version
  end

  module ClassMethods
    def instances
      all_instances
    end
  end

  module InstanceMethods
    protected

    def register_instance
      self.class.all_instances ||= 0
      self.class.all_instances += 1
    end
  end
end
