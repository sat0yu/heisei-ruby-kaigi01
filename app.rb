require 'sinatra'
require 'sinatra/json'
require 'rack/contrib'
require_relative 'graphql'

use Rack::PostBodyContentTypeParser

post '/graphql' do
  content_type :json
  puts params[:query]
  result = SampleGraphQL::Schema.execute(
    params[:query],
    variables: params[:variables],
    context: { current_user: nil },
  )
  json result
end
