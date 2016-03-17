require 'sinatra'
require 'json'
require "net/https"
require "uri"
require 'dotenv'
require "trello"

Dotenv.load

Trello.configure do |trello|
  trello.developer_public_key = ENV['TRELLO_DEVELOPER_PUBLIC_KEY']
  trello.member_token = ENV['TRELLO_MEMBER_TOKEN']
end

before do
  request.body.rewind
  @request_payload = JSON.parse request.body.read
end

post '/webhook' do
  card = Trello::Card.create(
    name: @request_payload['issue']['title'],
    list_id: ENV['MY_TARGET_LIST'],
    member_ids: [ Trello::Member.find(ENV['USER']).id ]
  )
end
