fiber = Fiber.new do
  puts "First"
  msg = Fiber.yield 1
  puts "Second: #{msg}"
  msg = Fiber.yield 2
  puts "Third: #{msg}"
  msg = Fiber.yield 3
  puts "Last: #{msg}"
end

puts fiber.resume
puts fiber.resume('a')
puts fiber.resume('b')
puts fiber.resume('c')
puts fiber.resume('?!')
