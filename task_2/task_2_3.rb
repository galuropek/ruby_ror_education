# frozen_string_literal: true

array = []
num_a = 0
num_b = 1

while num_a < 100
  array << num_a
  next_num = num_a + num_b
  num_a = num_b
  num_b = next_num
end

puts array
