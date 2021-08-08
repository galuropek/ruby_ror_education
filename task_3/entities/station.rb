# frozen_string_literal: true

require_relative '../modules/instance_counter'
require_relative '../modules/validation'
require_relative '../modules/accessors'

class Station
  include InstanceCounter
  include Validation
  extend Accessors

  attr_accessor_with_history :name
  attr_reader :trains

  validate :name, :presence
  validate :name, :format, /\w{3,}/
  validate :name, :type, String

  NAME_PATTERN = /^[А-я\d\s\-.]{3,}$/.freeze
  ERRORS = {
    pattern: 'Incorrect name pattern: >= 3 Cyrillic symbols or Numbers!',
    spaces: 'Found several spaces in sequence and name length < 3 after clearing!',
    dots: 'Found several dots in sequence and name length < 3 after clearing!',
    hyphens: 'Found several hyphens in sequence and name length < 3 after clearing!',
    beginning: 'Found incorrect chars in the beginning of name!'
  }.freeze

  @@instances = []

  def self.all
    @@instances
  end

  def initialize(name)
    @name = name
    @trains = []
    @@instances << self
    register_instance
    validate!
  end

  def add_train(train)
    @trains << train
  end

  def remove_train(train)
    @trains.delete(train)
  end

  def show_trains_by_type(type)
    @trains.select { |train| train.type == type }
  end

  def each_train(&block)
    trains.each { |train| block.call(train) }
  end

  def to_s
    name
  end
end
