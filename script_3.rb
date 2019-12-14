require_relative 'script_1'

def await(promise)
  Fiber.yield(promise)
end

def async_internal(fiber)
  chain = ->(result) {
    next_promise = result.then do |val|
      next_value = fiber.resume(val)
      return next_value unless next_value.is_a? Promise
      chain.call(next_value)
    end
    next_promise.sync
  }
  chain.call(fiber.resume)
end

def async(method_name, &block)
  define_method(method_name, ->(*args) {
    fiber = Fiber.new do
      GraphQL::Batch.batch do
        Fiber.yield(block.call(*args))
      end
    end
    async_internal(fiber)
  })
end

async :async_func do
  hoge1 = await HogeLoader.for(Hoge).load("bu")
  hoge2 = await HogeLoader.for(Hoge).load(hoge1.name + "y")
  hoge3 = await HogeLoader.for(Hoge).load(hoge2.name + "r")
  puts hoge3.inspect
end
