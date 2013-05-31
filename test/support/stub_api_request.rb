# Wrapper of webmock#stub_request

module StubAPIRequest
  def stub_api_request!(method, endpoint)
    endpoint.unshift('/') unless endpoint.start_with?('/')
    stub_request(:get, "https://#{API_KEY}:#{API_SECRET}@secure.sakura.ad.jp/cloud/api/cloud/1.0#{endpoint}")
      .to_return(body: instance_eval("stubbed_#{method}_response(endpoint)"))
  end
end
