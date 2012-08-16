require 'sinatra'

get '/' do
    "Hello, world"
end

post '/scout' do
  puts params[:payload]
end