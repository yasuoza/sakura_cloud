require 'test_helper'
require 'sakura_cloud'

class SakuraCloud::ServerAPITest < MiniTest::Unit::TestCase
  include StubJsonResponse
  include StubAPIRequest

  def test_list_servers
    stub_api_request!(:get, '/server')

    response = SakuraCloud::Server.all

    assert_equal response.from, 0
    assert_equal response.total, 3
    assert_equal response.servers.first.index, 0
    assert_equal response.servers.first.serverplan.memorymb, 2048
    assert_equal response.servers.first.instance.server.id, "112500052062"
    assert_equal response.servers.first.instance.cdromstorage.id, "3100195002"
  end
end
