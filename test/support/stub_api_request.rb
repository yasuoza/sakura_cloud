# Wrapper of webmock#stub_request

module StubAPIRequest
  def stub_api_key_secret!
    SakuraCloud.const_set('API_KEY', 'aaaaaaaaaaaaaaaaaaaaaaaa')
    SakuraCloud.const_set('API_SECRET', 'bbbbbbbbbbbbbbbbbbbbbbbb')
  end

  def stub_api_request!(method, endpoint)
    endpoint = '/' + endpoint unless endpoint.start_with?('/')

    stub_request(:get, "https://#{::SakuraCloud::API_KEY}:#{::SakuraCloud::API_SECRET}@secure.sakura.ad.jp/cloud/api/cloud/1.0#{endpoint}")
      .to_return(body: instance_eval("stubbed_#{method}_response(endpoint)"))
  end
end
