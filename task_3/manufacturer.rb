module Manufacturer
  def set_manufacturer(manufacturer)
    self.manufacturer = manufacturer
  end

  def get_manufacturer
    self.manufacturer
  end

  protected
  attr_accessor :manufacturer
end