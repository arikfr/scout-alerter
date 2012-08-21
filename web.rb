# encoding: utf-8
require 'sinatra'
require 'json'
require 'redis'
require 'boxcar_api'

require_relative 'sms.rb'
require_relative './lib/alert.rb'

uri = URI.parse(ENV["REDISTOGO_URL"])
REDIS = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)

def notify(message)
  #recipients = REDIS.get('recipients').split(',')
  #recipients.each do |recipient|
    #send_message(recipient, message)
  #end
  #send_message(recipients.first, message)

  provider = BoxcarAPI::Provider.new(ENV['BOXCAR_KEY'], ENV['BOXCAR_SECRET'])
  provider.broadcast(message)
end

get '/' do
  "Hello, world"
end

get '/test_message' do
  if params[:arik]
    provider = BoxcarAPI::Provider.new(ENV['BOXCAR_KEY'], ENV['BOXCAR_SECRET'])
    provider.broadcast('☁☂ Scout Alerter: test message (let Arik know you received it).')
  else
    notify('☁☂ Scout Alerter: test message (let Arik know you received it).')
  end
end

post '/scout' do
  payload = params[:payload]
  filtered_hostnames = REDIS.get('filtered_hostnames').split(',')
  recipients = REDIS.get('recipients').split(',')
  if payload
    alert = Alert.new(payload)
    notify(alert.message) if alert.needs_delivery?(filtered_hostnames)
  end
end