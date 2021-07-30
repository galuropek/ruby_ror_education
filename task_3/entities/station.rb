require_relative '../modules/instance_counter'
require_relative '../modules/validation'

class Station
  include InstanceCounter
  include Validation

=begin
О паттерне названия станции:
минимум 3 символа (киррилица, цифры + знаки препинания + пробелы)
примеры: "СП3", "Санкт-Петербург", "Нижний Новгород", "Н.Новгород"
Из-за пробелов в регулярке нужно делать доп проверку:
  name.gsub(/\s+/, ' ').strip.length >= 3
gsub(/\s+/, ' ') - для удаления наскольких пробелов в середине строки
=end
  NAME_PATTERN = /^[ А-я\d[[:punct:]]]{3,}$/

  attr_reader :name, :trains

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

  def to_s
    name
  end

  protected

  def validate!
    raise "Incorrect name pattern: >= 3 Cyrillic symbols or Numbers!" unless name =~ NAME_PATTERN
    raise "Found several spaces in sequence and name length < 3 after clearing!" unless name.gsub(/\s+/, ' ').strip.length >= 3
  end
end
