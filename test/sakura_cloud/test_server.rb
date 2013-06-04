require 'test_helper'
require 'sakura_cloud'

class SakuraCloud::ServerAPITest < MiniTest::Unit::TestCase
  include StubJsonResponse
  include StubAPIRequest

  def test_list_servers
    stub_api_request!(:get, '/server')

    servers = SakuraCloud::Server.all

    assert_equal servers.first.id, "112500052062"
    assert_equal servers.first.name, "saba1"
    assert_equal servers.first.description, ""
  end
end
