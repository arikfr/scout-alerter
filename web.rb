require 'sinatra'
require 'json'
require 'redis'
require_relative 'sms.rb'
require_relative './lib/alert.rb'

uri = URI.parse(ENV["REDISTOGO_URL"])
REDIS = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)

get '/' do
    "Hello, world"
end

get '/test_message' do
  recipients = REDIS.get('recipients').split(',')
  send_message(recipients, 'Scout Alerter: test message (let Arik know you received it).')
end

post '/scout' do
  payload = params[:payload]
  filtered_hostnames = REDIS.get('filtered_hostnames').split(',')
  recipients = REDIS.get('recipients').split(',')
  if payload
    alert = Alert.new(payload)
    send_message(recipients, alert.message) if alert.needs_delivery?(filtered_hostnames)
  end
end