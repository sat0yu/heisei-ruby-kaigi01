require 'graphql'
require 'graphql/batch'
require_relative 'script_3'

module SampleGraphQL
  module Types
    class Hoge < GraphQL::Schema::Object
      field :id, ID, null: false
      field :name, String, null: false
    end

    class Query < GraphQL::Schema::Object
      field :a, Types::Hoge, resolver_method: :nested_loaders, null: true
      field :b, Types::Hoge, resolver_method: :nested_loaders, null: true

      def nested_loaders
        HogeLoader.for(::Hoge).load("bu").then do |hoge1|
          HogeLoader.for(::Hoge).load(hoge1.name + "y").then do |hoge2|
            HogeLoader.for(::Hoge).load(hoge2.name + "r")
          end
        end
      end

      field :c, Types::Hoge, resolver_method: :async_await, null: true
      field :d, Types::Hoge, resolver_method: :async_await, null: true

      async :async_await do
        hoge1 = await HogeLoader.for(::Hoge).load("bu")
        hoge2 = await HogeLoader.for(::Hoge).load(hoge1.name + "y")
        HogeLoader.for(::Hoge).load(hoge2.name + "r")
      end
    end
  end

  class Schema < GraphQL::Schema
    query Types::Query
    use GraphQL::Batch
  end
end
