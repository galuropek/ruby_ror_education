class Station
  attr_reader :trains

  def initialize(name)
    @name = name
    @trains = []
  end

  def add_train(train)
    @trains << train
  end

  def train_departure(train)
    @trains.delete(train)
  end

  def show_trains_by_type(type)
    @trains.select { |train| train.type == type }
  end
end