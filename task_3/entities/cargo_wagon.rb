require_relative 'wagon'

class CargoWagon < Wagon

  attr_accessor :overall_volume

  def initialize(type, overall_volume)
    super(type)
    @overall_volume = overall_volume
    @occupied_volume = 0.0
  end

  def add_cargo(volume)
    @occupied_volume += volume if (@occupied_volume + volume) < overall_volume
  end

  def occupied_volume
    @occupied_volume
  end

  def free_volume
    overall_volume - @occupied_volume
  end
end