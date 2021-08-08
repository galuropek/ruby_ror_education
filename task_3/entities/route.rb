# frozen_string_literal: true

require_relative '../modules/instance_counter'
require_relative '../modules/validation'

require_relative 'station'

class Route
  include InstanceCounter
  include Validation

  attr_reader :starting_station, :intermediate_stations, :end_station

  validate :starting_station, :presence
  validate :starting_station, :type, Station
  validate :end_station, :presence
  validate :end_station, :type, Station

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
    stations.map(&:name).join(' -> ')
  end
end
