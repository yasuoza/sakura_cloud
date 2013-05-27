require_relative "sakura_cloud/version"
require 'json'
require 'net/https'
require 'uri'

load File.join(ENV['HOME'], ".sakura_cloud.rb")

require_relative 'sakura_cloud/request.rb'
require_relative 'sakura_cloud/response.rb'
