print "Введите ваше имя: "
first_name = gets.chomp.capitalize
print "Введите ваш рост: "
height = gets.chomp

perfect_weight = (height.to_i - 110) * 1.15

if perfect_weight.negative?
  puts "Ваш вес уже оптимальный"
else
  puts "#{first_name}, ваш идеальный вес: #{perfect_weight}"
end