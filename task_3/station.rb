class Station
  attr_reader :name, :trains

  @@all_created_stations = []

  def self.all
    @@all_created_stations
  end

  def initialize(name)
    @name = name
    @trains = []
    @@all_created_stations << self
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
