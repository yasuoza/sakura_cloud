require 'test_helper'

require 'response'

class SakuraCloud::ResponseTest < MiniTest::Unit::TestCase

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

end
