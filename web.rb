# encoding: utf-8
require 'sinatra'
require 'json'
require 'redis'
require 'boxcar_api'

require_relative './lib/alert.rb'

uri = URI.parse(ENV["REDISTOGO_URL"])
REDIS = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password)

def notify(message)
  provider = BoxcarAPI::Provider.new(ENV['BOXCAR_KEY'], ENV['BOXCAR_SECRET'])
  provider.broadcast(message)
end

get '/' do
  "Nothign to see here, move along."
end

get '/test_message' do
  notify('☁☂ Scout Alerter: test message (let Arik know you received it).')
end

post '/scout' do
  payload = params[:payload]
  filtered_hostnames = REDIS.get('filtered_hostnames').split(',')
  if payload
    alert = Alert.new(payload)
    notify(alert.message) if alert.needs_delivery?(filtered_hostnames)
  end
end