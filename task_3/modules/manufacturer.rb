module Manufacturer
  attr_reader :manufacturer

  def set_manufacturer(manufacturer)
    self.manufacturer = manufacturer
  end

  protected
  attr_writer :manufacturer
end