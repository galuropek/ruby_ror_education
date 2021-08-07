# frozen_string_literal: true

print 'Введите основание треугольника: '
base_of_triangle = gets.chomp.to_f
print 'Введите высоту треугольника: '
height_of_triangle = gets.chomp.to_f

area_of_triangle = 1.0 / 2 * base_of_triangle * height_of_triangle
puts "Площадь треульника: #{area_of_triangle}"
