require_relative "sakura_cloud/version"
require 'json'
require 'net/https'
require 'uri'

unless defined?(SakuraCloud::API_KEY) && defined?(SakuraCloud::API_SECRET)
  load File.join(ENV['HOME'], ".sakura_cloud.rb")
end

require_relative 'sakura_cloud/util'
require_relative 'sakura_cloud/request'
require_relative 'sakura_cloud/response'
require_relative 'sakura_cloud/abstract_api_class'
require_relative 'sakura_cloud/server'
require_relative 'sakura_cloud/disk'
