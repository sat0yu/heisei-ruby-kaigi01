require 'promise'
require 'graphql/batch'

class Hoge
  attr_accessor :id, :name
  def initialize(id:, name:)
    @id = id
    @name = name
  end

  def self.getAll(ids)
    ids.map{ |id| self.new(id: id, name: id.to_s.reverse) }
  end
end

class HogeLoader < GraphQL::Batch::Loader
  def initialize(model)
    @model = model
  end

  def perform(ids)
    puts "called HogeLoader#perform with ids: #{ids}"
    @model.getAll(ids).each { |obj| fulfill(obj.id, obj) }
    ids.each { |id| fulfill(id, nil) unless fulfilled?(id) }
  end
end

def nested_loaders
  GraphQL::Batch.batch do
    HogeLoader.for(Hoge).load("bu").then do |hoge1|
      puts hoge1.inspect
      HogeLoader.for(Hoge).load(hoge1.name + "y").then do |hoge2|
        puts hoge2.inspect
        HogeLoader.for(Hoge).load(hoge2.name + "r").then do |hoge3|
          puts hoge3.inspect
        end
      end
    end
  end
end
