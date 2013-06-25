require 'test_helper'
require 'core_ext/all'
require 'sakura_cloud/response'

class SakuraCloud::ResponseTest < MiniTest::Unit::TestCase
  include StubJsonResponse

  def test_hashnize
    hash_obj = {
      A: 1,
      B: {
        C: [
          {D: 2},
          {E: 3},
          {F: [4, 5, 6]}
        ]
      }
    }
    response = SakuraCloud::Response.new(MultiJson.encode(hash_obj))

    assert_equal response[:a], 1
    assert_equal response[:b][:c][0][:d], 2
    assert_equal response[:b][:c][1][:e], 3
    assert_equal response[:b][:c][2][:f], [4, 5, 6]
  end

  def test_get_server_response
    response = SakuraCloud::Response.new(stubbed_get_response('/server'))
    assert_equal response[:from], 0
    assert_equal response[:total], 3
    assert_equal response[:servers].first[:index], 0

    assert_equal response[:servers].first[:server_plan][:memorymb], 2048
    assert_equal response[:servers].first[:instance][:server][:id], "112500052062"
    assert_equal response[:servers].first[:instance][:cdromstorage][:id], "3100195002"
  end

  def test_get_server_response
    failed_response_body = 'Hello failed response!'
    response = SakuraCloud::Response.new(failed_response_body)
    assert !response[:is_ok]
    assert_equal response[:body], failed_response_body
  end
end
