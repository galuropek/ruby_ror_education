require_relative 'modules/instance_counter'

class Station
  include InstanceCounter

  attr_reader :name, :trains

  @@instances = []

  def self.all
    @@instances
  end

  def initialize(name)
    @name = name
    @trains = []
    @@instances << self
    register_instance
  end

  def add_train(train)
    @trains << train
  end

  def remove_train(train)
    @trains.delete(train)
  end

  def show_trains_by_type(type)
    @trains.select { |train| train.type == type }
  end

  def to_s
    name
  end
end
