require 'bundler'

begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end

require 'minitest/autorun'

module StubJsonResponse
  def stubbed_get_response(endpoint)
    stubbed_response('GET', endpoint)
  end

  def stubbed_response(method='GET', endpoint)
    endpoint.unshift('/') unless endpoint.start_with?('/')
    endpoint.gsub!('/', "/#{method.downcase}_")
    File.read(File.dirname(__FILE__) + "/fixtures/responses#{endpoint}.json").chomp
  end
end
