require 'test_helper'
require 'sakura_cloud/plan'

class SakuraCloud::PlanTest < MiniTest::Unit::TestCase
  include StubJsonResponse
  include StubAPIRequest

  def test_init_with_mininum_val
    plan = SakuraCloud::Plan.new

    assert_equal plan.id, SakuraCloud::Plan::MINIMUM_PLAN[:id]
    assert_equal plan.name, SakuraCloud::Plan::MINIMUM_PLAN[:name]
    assert_equal plan.cpu, SakuraCloud::Plan::MINIMUM_PLAN[:cpu]
    assert_equal plan.memory_mb, SakuraCloud::Plan::MINIMUM_PLAN[:memory_mb]
    assert_equal plan.server_class, SakuraCloud::Plan::MINIMUM_PLAN[:server_class]
    assert_equal plan.availability, SakuraCloud::Plan::MINIMUM_PLAN[:availability]
  end

  def test_with_custom_val
    plan = SakuraCloud::Plan.new id: 2, cpu: 2, memory_mb: 4096

    assert_equal plan.id, 2
    assert_equal plan.cpu, 2
    assert_equal plan.memory_mb, 4096
  end
end

