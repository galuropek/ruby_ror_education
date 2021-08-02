require_relative 'wagon'

class PassengerWagon < Wagon

  attr_accessor :number_of_seats

  def initialize(type, number_of_seats)
    super(type)
    @number_of_seats = number_of_seats
    @occupied_seats = 0
  end

  def add_filling
    @occupied_seats += 1 if @occupied_seats < number_of_seats
  end

  def occupied_filling
    @occupied_seats
  end

  def free_filling
    number_of_seats - @occupied_seats
  end
end