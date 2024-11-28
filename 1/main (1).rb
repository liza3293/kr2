require 'thread'

# Створення тестових файлів (імітація локального каталогу)
Dir.mkdir("files") unless Dir.exist?("files")
File.write("files/file1.txt", "Це тестовий файл 1\nРядок 2")
File.write("files/file2.txt", "Це тестовий файл 2\nРядок 2\nРядок 3")
File.write("files/file3.txt", "Це тестовий файл 3")

# Метод для обробки файлу
def process_file(file_path)
  begin
    lines_count = File.readlines(file_path).size
    puts "Файл: #{file_path} містить #{lines_count} рядків"
  rescue => e
    puts "Помилка при обробці файлу #{file_path}: #{e.message}"
  end
end

# Шлях до каталогу
directory_path = "./files"

# Отримуємо список файлів у каталозі
files = Dir.glob("#{directory_path}/*").select { |file| File.file?(file) }

# Перевірка, чи є файли в каталозі
if files.empty?
  puts "Каталог порожній або не існує."
  exit
end

# Черга для багатопотокової обробки
queue = Queue.new
files.each { |file| queue << file }

# Кількість потоків
thread_count = 4

# Створення потоків
threads = thread_count.times.map do
  Thread.new do
    while !queue.empty?
      file = queue.pop(true) rescue nil
      process_file(file) if file
    end
  end
end

# Очікування завершення потоків
threads.each(&:join)

puts "Обробка завершена."
