# frozen_string_literal: true

require_relative 'wagon'

class PassengerWagon < Wagon
  def take_place
    @taken_place += 1 if @taken_place < @place
  end
end
