require_relative 'wagon'

class CargoWagon < Wagon

  attr_accessor :overall_volume

  def initialize(type, overall_volume)
    super(type)
    @overall_volume = overall_volume
    @occupied_volume = 0.0
  end

  def add_filling(filling)
    @occupied_volume += filling if (@occupied_volume + filling) < overall_volume
  end

  def occupied_filling
    @occupied_volume
  end

  def free_filling
    overall_volume - @occupied_volume
  end
end