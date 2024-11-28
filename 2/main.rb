require 'thread'

# Створення вхідного файлу з числами
input_file = "numbers.txt"
output_file = "squares.txt"

# Генерація вхідного файлу з випадковими числами
File.open(input_file, "w") do |file|
  1.upto(20) { |i| file.puts(rand(1..100)) }
end

# Метод для обробки числа: обчислення квадрата
def process_number(number, output_file)
  square = number.to_i**2
  File.open(output_file, "a") do |file|
    file.puts(square)
  end
end

# Читаємо числа з вхідного файлу
numbers = File.readlines(input_file).map(&:strip)

# Черга для зберігання чисел
queue = Queue.new
numbers.each { |number| queue << number }

# Кількість потоків
thread_count = 4

# Створюємо потоки для обробки
threads = thread_count.times.map do
  Thread.new do
    while !queue.empty?
      number = queue.pop(true) rescue nil
      process_number(number, output_file) if number
    end
  end
end

# Очікуємо завершення всіх потоків
threads.each(&:join)

puts "Обробка завершена. Результати записано у файл #{output_file}."

# Перевірка результатів
puts "Вміст файлу #{output_file}:"
puts File.read(output_file)
