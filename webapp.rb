require 'sinatra'
require 'json'
require "net/https"
require "uri"

before do
  request.body.rewind
  @request_payload = JSON.parse request.body.read
end

post '/gitlab/webhook' do
  user_name = @request_payload["user_name"]
  repository_name = @request_payload["repository"]["name"]
  commits = @request_payload["commits"]

  title = "#{user_name} pushed to git.42la.bs #{repository_name}"
  messages = '<ul>' + commits.map do |commit|
    "<li>#{commit['message']}</li>"
  end.join + '</ul>'

  puts messages
end
