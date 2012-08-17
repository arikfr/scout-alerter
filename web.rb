require 'sinatra'
require 'json'
require_relative 'sms.rb'
require_relative './lib/alert.rb'

get '/' do
    "Hello, world"
end

get '/test_message' do
  send_message('972542186395', 'Testing.')
end

post '/scout' do
  payload = params[:payload]
  if payload
    alert = Alert.new(payload)
    send_message('972542186395', alert.message)
  end
end