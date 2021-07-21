basket = Hash.new

loop do
  puts "Введите название товара: "
  name = gets.chomp
  break if name == "стоп"

  puts "Введите цену товара за единицу: "
  price = gets.to_f
  puts "Введите количество: "
  quantity = gets.to_f

  basket[name] = {
    price: price,
    quantity: quantity
  }
end

basket.each do |name, values|
  sum = values[:price] * values[:quantity]
  puts "Товар: #{name}, цена: #{values[:price]}, количество: #{values[:quantity]}, сумма: #{sum}"
end

all_baset_sum = basket.values.map { |value| value[:price] * value[:quantity] }.sum
puts "Общая сумма корзины: #{all_baset_sum}"