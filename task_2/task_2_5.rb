require 'date'

puts "Введите день месяца: "
day = gets.chomp.to_i
puts "Введите порядковый номер месяца: "
month = gets.chomp.to_i
puts "Введите год: "
year = gets.chomp.to_i

high_year = (year % 400 == 0) || (year % 4 == 0 && year % 100 != 0)

months = {
  1 => 31,
  2 => high_year ? 29 : 28,
  3 => 31,
  4 => 30,
  5 => 31,
  6 => 30,
  7 => 31,
  8 => 31,
  9 => 30,
  10 => 31,
  11 => 30,
  12 => 31
}

result = day

for i in 1..month.pred do
  result += months[i]
end

puts "Порядковый номер даты: #{result}"