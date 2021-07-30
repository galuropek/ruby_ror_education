module Manufacturer
  attr_reader :manufacturer

  def set_manufacturer(manufacturer)
    self.manufacturer = manufacturer
  end

  protected
  # ожидется изменение только через метод set_manufacturer
  attr_writer :manufacturer
end