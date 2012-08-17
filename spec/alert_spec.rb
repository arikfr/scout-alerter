require 'rspec'
require_relative '../lib/alert.rb'

describe Alert do
  let(:payload) do
    <<-EOF
    {
      "id": 999999,
      "time": "2012-03-05T15:36:51Z",
      "server_name": "Blade",
      "server_hostname": "blade",
      "lifecycle": "start", // can be [start|end]
      "title": "Last minute met or exceeded 3.00 , increasing to 3.50 at 01:06AM",
      "plugin_name": "Load Average",
      "metric_name": "last_minute",
      "metric_value": 3.5,
      "severity": "warning", // warning = normal threshold, critical = SMS threshold
      "url": "https://scoutapp.com/a/999999"
    }
EOF
  end

  describe ".new" do
    it "creates new Alert object" do
      Alert.new(payload).should be_instance_of(Alert)
    end
  end

  describe "#message" do
    it "returns message for given payload" do
      alert = Alert.new(payload)
      alert.message.should == "blade>Load Average>Started: Last minute met or exceeded 3.00 , increasing to 3.50 at 01:06AM" 
    end

    it "converts lifecycle start to started" do
      Alert.new(payload).message.should include('Started')
    end

    it "converts lifecycle end to ended" do
      end_payload = payload
      end_payload = end_payload.gsub('start', 'end')
      Alert.new(end_payload).message.should include('Ended')
    end
  end

  describe "#needs_delivery?" do
    it "returns true if hostname isn't in filtered host list" do
      Alert.new(payload).needs_delivery?(['test']).should be_true
    end

    it "returns false if hostname is in filtered host list" do
      Alert.new(payload).needs_delivery?(['test', 'blade']).should be_false
    end
  end
end