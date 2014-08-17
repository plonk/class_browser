require 'sinatra'
require 'sinatra/reloader'
require 'shellwords'

set port: 8080
set environment: :production

get '/' do
  erb :index
end

get '/render' do
  erb :render
end
