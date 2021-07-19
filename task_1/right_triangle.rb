sides = []

print "Введите размер стороны А: "
sides << gets.chomp.to_f
print "Введите размер стороны B: "
sides << gets.chomp.to_f
print "Введите размер стороны C: "
sides << gets.chomp.to_f

sides.sort!
largest_side = sides.pop

if sides.first ** 2 + sides.last ** 2 == largest_side ** 2
  puts "Треугольник является прямоугольным"
elsif sides.first == largest_side && sides.last == largest_side
  puts "Треугольник является равносторонним"
elsif sides.first == sides.last
  puts "Треугольник является равнобедренным"
else
  puts "Треугольник не является ни прямоугольным, ни равносторонним, ни равнобедренным"
end