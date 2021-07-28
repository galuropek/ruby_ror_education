class Wagon

  attr_reader :type

  def initialize(type)
    @type = type
  end

  def to_s
    "Вагон: id - #{self.object_id}, тип - #{type}"
  end
end