require_relative 'script_1'

def rewrite_with_fiber
  fiber = Fiber.new do
    GraphQL::Batch.batch do
      hoge1 = Fiber.yield HogeLoader.for(Hoge).load("bu")
      hoge2 = Fiber.yield HogeLoader.for(Hoge).load(hoge1.name + "y")
      hoge3 = Fiber.yield HogeLoader.for(Hoge).load(hoge2.name + "r")
      puts hoge3.inspect
    end
  end

  p1 = fiber.resume
  next_p1 = p1.then do |v1|
    p2 = fiber.resume(v1)
    next_p2 = p2.then do |v2|
      p3 = fiber.resume(v2)
      next_p3 = p3.then do|v3|
        fiber.resume(v3)
      end
      next_p3.sync
    end
    next_p2.sync
  end
  next_p1.sync
end
