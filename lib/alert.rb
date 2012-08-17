require 'json'

class Alert
  def initialize(payload)
    @payload = payload
    @json = JSON.parse(@payload)
  end

  def message
    states = {"end" => "Ended", "start" => "Started"}
    message = "#{@json['server_hostname']}>#{@json['plugin_name']}>#{states[@json['lifecycle']]}: " + @json['title'].strip
  end
end
