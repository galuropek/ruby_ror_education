require_relative '../modules/manufacturer'
require_relative '../modules/validation'

class Wagon
  include Manufacturer
  include Validation

  attr_reader :type

  EXPECTED_TYPES = [:cargo, :passenger]

  def initialize(type)
    @type = type
    validate!
  end

  def to_s
    "Вагон: id - #{self.object_id}, тип - #{type}"
  end

  protected

  def validate!
    raise "Unexpected type! Expected: #{EXPECTED_TYPES}" unless EXPECTED_TYPES.include?(type)
  end
end