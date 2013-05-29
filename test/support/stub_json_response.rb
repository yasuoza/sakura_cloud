module StubJsonResponse
  def stubbed_get_response(endpoint)
    stubbed_response('GET', endpoint)
  end

  def stubbed_response(method='GET', endpoint)
    endpoint.unshift('/') unless endpoint.start_with?('/')
    endpoint.gsub!('/', "/#{method.downcase}_")
    File.read(File.dirname(__FILE__) + "/../fixtures/responses#{endpoint}.json").chomp
  end
end
