my_hash = {}
all_vowels = /[ауоыиэяюёе]/i

('а'..'я').to_a.each_with_index do |char, index|
  my_hash[char] = index.next if char =~ all_vowels
end

my_hash.each { |char, number| puts "#{char} - #{number}" }