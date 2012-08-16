require 'sinatra'
require 'json'
require_relative 'sms.rb'

get '/' do
    "Hello, world"
end

get '/test_message' do
  send_message('972542186395', 'Testing.')
end

post '/scout' do
  payload = params[:payload]
  states = {"end"=>"Ended", "start"=>"started"}
  if payload
    json = JSON.parse(payload)
    message = "#{json['server_hostname']}]#{json['plugin_name']}]#{states[json['lifecycle']]}: " + json['title'].strip
    send_message('972542186395', message)
  end
end