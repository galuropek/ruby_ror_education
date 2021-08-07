# frozen_string_literal: true

require_relative 'wagon'

class CargoWagon < Wagon
  def take_place(units)
    @taken_place += units if @place >= (@taken_place + units)
  end
end
