require 'test_helper'

require 'sakura_cloud/response'

class SakuraCloud::ResponseTest < MiniTest::Unit::TestCase
  include StubJsonResponse

  def test_methodnize
    hash_obj = {
      a: 1,
      b: {
        c: [
          {d: 2},
          {e: 3},
          {f: [4, 5, 6]}
        ]
      }
    }
    response = SakuraCloud::Response.new(MultiJson.encode(hash_obj))

    assert_equal response.a, 1
    assert_equal response.b.c[0].d, 2
    assert_equal response.b.c[1].e, 3
    assert_equal response.b.c[2].f, [4, 5, 6]
  end

  def test_get_server_response
    response = SakuraCloud::Response.new(stubbed_get_response('/server'))
    assert_equal response.from, 0
    assert_equal response.total, 3
    assert_equal response.servers.first.index, 0

    assert_equal response.servers.first.serverplan.memorymb, 2048
    assert_equal response.servers.first.instance.server.id, "112500052062"
    assert_equal response.servers.first.instance.cdromstorage.id, "3100195002"
  end
end
