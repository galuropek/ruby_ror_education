# frozen_string_literal: true

module Manufacturer
  attr_reader :manufacturer

  def add_manufacturer(manufacturer)
    self.manufacturer = manufacturer
  end

  protected

  attr_writer :manufacturer
end
