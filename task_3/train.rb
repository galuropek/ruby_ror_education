class Train
  attr_accessor :speed
  attr_reader :railway_carriage_count, :current_station

  EXPECTED_TYPES = %w[freight passenger]

  def initialize(number, type, railway_carriage_count)
    @number = number
    @type = EXPECTED_TYPES.find { |e_type| e_type == type }
    raise "Incorrect train type" unless @type

    @railway_carriage_count = railway_carriage_count
    @speed = 0
    @route = nil
  end

  def stop
    self.speed = 0
  end

  def add_railway_carriage
    @railway_carriage_count += 1 if speed.zero?
  end

  def remove_railway_carriage
    @railway_carriage_count -= 1 if speed.zero? && @railway_carriage_count.positive?
  end

  def add_route(route)
    @route = route
    @current_station = route.full_route.first
  end

  def move_to_next_station
    @current_station = next_station || @current_station # set current_station if current_station is a last element in the array
  end

  def move_to_prev_station
    @current_station = prev_station
  end

  def next_station
    @route.full_route[current_station_index.next]
  end

  def prev_station
    index_of_prev_station = current_station_index.pred
    return if index_of_prev_station.negative?

    @route.full_route[index_of_prev_station]
  end

  private

  def current_station_index
    @route.full_route.index(@current_station)
  end
end