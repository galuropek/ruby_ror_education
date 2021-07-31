require_relative '../modules/instance_counter'
require_relative '../modules/validation'

class Route
  include InstanceCounter
  include Validation

  attr_reader :intermediate_stations

  def initialize(starting_station, end_station)
    @starting_station = starting_station
    @end_station = end_station
    @intermediate_stations = []
    register_instance
    validate!
  end

  def add_station(station)
    @intermediate_stations << station
  end

  def remove_station(station)
    @intermediate_stations.delete(station)
  end

  def stations
    route = []
    route << @starting_station
    route.concat(@intermediate_stations)
    route << @end_station
    route
  end

  def to_s
    self.stations.map { |station| station.name }.join(' -> ')
  end

  protected

  def validate!
    errors = []
    errors << "Incorrect starting_station!" unless @starting_station.valid?
    errors << "Incorrect end_station!" unless @end_station.valid?
    raise errors.join(" ") unless errors.empty?
  end
end