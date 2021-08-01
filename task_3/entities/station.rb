require_relative '../modules/instance_counter'
require_relative '../modules/validation'

class Station
  include InstanceCounter
  include Validation

=begin
О паттерне названия станции:
минимум 3 символа (кириллица, цифры, дефис, пробел, точка)
ожидаемые примеры: "СП3", "Санкт-Петербург", "Нижний Новгород", "Н.Новгород"
=end
  NAME_PATTERN = /^[А-я\d\s\-\.]{3,}$/

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

  def each_train(&block)
    trains.each { |train| block.call(train) }
  end

  def to_s
    name
  end

  protected

  def validate!
    errors = []
    errors << "Incorrect name pattern: >= 3 Cyrillic symbols or Numbers!" unless name =~ NAME_PATTERN
    # из-за доп символов в регулярке нужны проверки кейсов с их повторением и использованием в начале названия
    # к примеру: "  А", "A  ", "..A", "A.." и т.д.
    errors << "Found several spaces in sequence and name length < 3 after clearing!" unless name.gsub(/\s+/, ' ').strip.length >= 3
    errors << "Found several dots in sequence and name length < 3 after clearing!" unless name.gsub(/\.+/, '.').strip.length >= 3
    errors << "Found several hyphens in sequence and name length < 3 after clearing!" unless name.gsub(/-+/, '-').strip.length >= 3
    # проверка, чтобы название начиналось с буквы или цифры, а не доп символов из ркгулярки
    # сработает на: ".Париж", "-Париж", " Париж"
    errors << "Found incorrect chars in the beginning of name!" unless name =~ /^[А-я\d]+/
    raise errors.join(" ") unless errors.empty?
  end
end
