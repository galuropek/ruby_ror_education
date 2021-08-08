# frozen_string_literal: true

require_relative '../modules/manufacturer'
require_relative '../modules/validation'

class Wagon
  include Manufacturer
  include Validation

  attr_reader :type, :taken_place
  attr_accessor :place

  validate :type, :presence
  validate :type, :type, Symbol
  validate :place, :presence
  validate :place, :type, Numeric

  EXPECTED_TYPES = %i[cargo passenger].freeze

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
    raise 'Not implemented!'
  end

  def to_s
    "id: #{object_id}, тип: #{type}"
  end
end
