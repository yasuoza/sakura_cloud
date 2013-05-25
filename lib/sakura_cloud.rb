# vim:fileencoding=utf-8
require_relative "sakura_cloud/version"
require 'json'
require 'net/https'
require 'uri'

load File.join(ENV['HOME'], ".sakura_cloud.rb")

require_relative 'request.rb'
require_relative 'response.rb'

if $0 == __FILE__
end
