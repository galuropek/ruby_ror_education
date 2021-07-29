class Train
  attr_accessor :speed
  attr_reader :wagons, :current_station, :route, :number, :type

  @@all_created_trains = []

  def self.find(number)
    @@all_created_trains.find { |train| train.number == number }
  end

  def initialize(number, type)
    @number = number
    @type = type
    @wagons = []
    @speed = 0
    @@all_created_trains << self
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
    if next_station
      current_station.trains.delete(self)
      self.current_station = next_station
      current_station.trains << self
    end
  end

  def move_to_prev_station
    if prev_station
      current_station.trains.delete(self)
      self.current_station = prev_station
      current_station.trains << self
    end
  end

  def next_station
    route.stations[current_station_index.next]
  end

  def prev_station
    return if current_station_index.pred.negative?

    route.stations[current_station_index.pred]
  end

  def to_s
    "Поезд: номер - #{number}, тип - #{type}"
  end

  protected

  # ожидается изменение этих переменных только внутри класса
  attr_writer :wagons, :current_station, :route

  # используется как вспомогательный метод только внутри класса
  def current_station_index
    route.stations.index(current_station)
  end

  # используется как вспомогательный метод только внутри класса
  def the_same_type?(wagon)
    type == wagon.type
  end

  def print_warn(wagon)
    puts "#{wagon.to_s} не добавлен к #{self.to_s} - разные типы"
  end
end