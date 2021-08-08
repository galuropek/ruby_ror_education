# frozen_string_literal: true

require_relative '../modules/instance_counter'
require_relative '../modules/manufacturer'
require_relative '../modules/validation'

class Train
  include InstanceCounter
  include Manufacturer
  include Validation

  attr_accessor :speed
  attr_reader :wagons, :current_station, :route, :number, :type

  validate :number, :presence
  validate :number, :format, /^[А-я\w]{3}-*[А-я\w]{2}$/
  validate :number, :type, String
  validate :type, :presence
  validate :type, :type, Symbol

  EXPECTED_TYPES = %i[cargo passenger].freeze

  @@instances = []

  def self.find(number)
    @@instances.find { |train| train.number == number }
  end

  def initialize(number, type)
    @number = number
    @type = type
    @wagons = []
    @speed = 0
    @@instances << self
    register_instance
    validate!
  end

  def stop
    self.speed = 0
  end

  def add_wagon(wagon)
    the_same_type?(wagon) ? wagons << wagon : print_warn(wagon)
  end

  def remove_wagon(wagon)
    wagons.delete(wagon)
  end

  def add_route(route)
    self.route = route
    self.current_station = route.stations.first
    current_station.trains << self
  end

  def move_to_next_station
    return unless next_station

    current_station.trains.delete(self)
    self.current_station = next_station
    current_station.trains << self
  end

  def move_to_prev_station
    return unless prev_station

    current_station.trains.delete(self)
    self.current_station = prev_station
    current_station.trains << self
  end

  def next_station
    route.stations[current_station_index.next]
  end

  def prev_station
    return if current_station_index.pred.negative?

    route.stations[current_station_index.pred]
  end

  def each_wagon(&block)
    wagons.each { |wagon| block.call(wagon) }
  end

  def to_s
    "номер: #{number}, тип: #{type}"
  end

  protected

  attr_writer :wagons, :current_station, :route

  def current_station_index
    route.stations.index(current_station)
  end

  def the_same_type?(wagon)
    type == wagon.type
  end

  def print_warn(wagon)
    puts "Вагон (#{wagon}) не добавлен к плезду (#{self}) - разные типы!"
  end
end
