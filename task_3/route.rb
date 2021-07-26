class Route

  def initialize(starting_station, end_station)
    @starting_station = starting_station
    @end_station = end_station
    @intermediate_stations = []
  end

  def add_station(station)
    @intermediate_stations << station
  end

  def remove_station(station)
    @intermediate_stations.delete(station)
  end

  def full_route
    route = []
    route << @starting_station
    route.concat(@intermediate_stations)
    route << @end_station
    route
  end
end