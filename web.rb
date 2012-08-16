require 'sinatra'

get '/' do
    "Hello, world"
end

post '/scout' do
  puts "received: #{params[:payload]}"
end