#!/usr/bin/env ruby
require 'sinatra'
require 'json'
require 'uri'

SLACK="https://thoughtworks.slack.com/services/hooks/incoming-webhook?token=#{ENV['SLACK_TOKEN']}"

post '/' do
  data = URI.escape "payload=#{payload}"

  %x[curl -v -X POST -d '#{data}' '#{SLACK}']
end

def payload
  {
    channel: ENV['SLACK_CHANNEL'],
    username: 'snap-bot',
    icon_url: 'https://snap-ci.com/assets/logos/stripe-snap-logo-black-17acc043bae4e7ae772f7a8f4168dec3.png',
    text: message
  }.to_json
end

def message
  params = JSON.parse(request.env["rack.input"].read)
  "#{params["stage_name"]} build ##{params["counter"]} <https://snap-ci.com/#{params["project_name"]}/branch/master|#{params["build_result"]}>"
end
