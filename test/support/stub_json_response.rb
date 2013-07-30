module StubJsonResponse
  def stubbed_get_response(endpoint)
    stubbed_response('GET', endpoint)
  end

  def stubbed_post_response(endpoint)
    stubbed_response('POST', endpoint)
  end

  def stubbed_response(method='GET', endpoint)
    endpoint = method.downcase + '_' + endpoint.sub(/^\//, '').gsub('/', '_')

    File.read(File.dirname(__FILE__) + "/../fixtures/responses/#{endpoint}.json").chomp
  end
end
