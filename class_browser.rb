def strip_dtd svg
  svg.each_line.drop(3).join
end

def postprocess_svg(svg, library)
  autolink(strip_dtd(svg), library)
end

def autolink svg, library
  svg.gsub(/(?<=>)[A-z_:]+(?=<\/text>)/) { |name| "<a xlink:href=\"/render?class=#{name}&amp;library=#{library}\">#{name}</a>" }
end

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
