print "Введите коэффициент А: "
a = gets.chomp.to_f
print "Введите коэффициент B: "
b = gets.chomp.to_f
print "Введите коэффициент C: "
c = gets.chomp.to_f

d = b ** 2 - 4 * a * c

if d > 0
  x = (-b + Math.sqrt(d)) / (2 * a)
  x2 = (-b - Math.sqrt(d)) / (2 * a)
  puts "Дискриминант: #{d}, x1: #{x}, x2: #{x2}"
elsif d.zero?
  x = -b / (2 * a)
  puts "Дискриминант: #{d}, x: #{x}"
else
  puts "Дискриминант: #{d}. Корней нет!"
end
