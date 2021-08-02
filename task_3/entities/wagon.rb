require_relative '../modules/manufacturer'
require_relative '../modules/validation'

class Wagon
  include Manufacturer
  include Validation

  attr_reader :type, :taken_place
  attr_accessor :place

  EXPECTED_TYPES = [:cargo, :passenger]

  def initialize(type, place)
    @type = type
    @place = place
    @taken_place = 0.0
    validate!
  end

  def free_place
    place - taken_place
  end

  def take_place
    raise "Not implemented!"
  end

  def to_s
    "id: #{self.object_id}, тип: #{type}"
  end

  protected

  def validate!
    errors = []
    errors << "Unexpected type! Expected: #{EXPECTED_TYPES}" unless EXPECTED_TYPES.include?(type)
    errors << "Empty place!" if place.to_f.zero?
    raise errors.join(" ") unless errors.empty?
  end
end