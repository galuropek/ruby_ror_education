# frozen_string_literal: true

require_relative '../modules/instance_counter'
require_relative '../modules/validation'

class Station
  include InstanceCounter
  include Validation

  NAME_PATTERN = /^[А-я\d\s\-.]{3,}$/.freeze
  ERRORS = {
    pattern: 'Incorrect name pattern: >= 3 Cyrillic symbols or Numbers!',
    spaces: 'Found several spaces in sequence and name length < 3 after clearing!',
    dots: 'Found several dots in sequence and name length < 3 after clearing!',
    hyphens: 'Found several hyphens in sequence and name length < 3 after clearing!',
    beginning: 'Found incorrect chars in the beginning of name!'
  }.freeze

  attr_reader :name, :trains

  @@instances = []

  def self.all
    @@instances
  end

  def initialize(name)
    @name = name
    @trains = []
    @@instances << self
    @errors = []
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

  protected

  def validate!
    @errors << ERRORS[:pattern] unless name =~ NAME_PATTERN
    @errors << ERRORS[:beginning] unless name =~ /^[А-я\d]+/
    raise @errors.join(' ') unless @errors.empty?
  end

  def validate_length_name
    @errors << ERRORS[:spaces] unless length_is_correct?(/\s+/, ' ')
    @errors << ERRORS[:dots] unless length_is_correct?(/\.+/, '.')
    @errors << ERRORS[:hyphens] unless length_is_correct?(/-+/, '-')
  end

  def length_is_correct?(regexp, str, correct_value = 3)
    name.gsub(regexp, str).strip.length >= correct_value
  end
end
