require 'test_helper'
require 'sakura_cloud'
require 'sakura_cloud/plan'

class SakuraCloud::PlanTest < MiniTest::Unit::TestCase
  include StubJsonResponse
  include StubAPIRequest

  def setup
    stub_api_request!(:get, '/product/server')
  end

  def test_init_with_mininum_plan
    plan = SakuraCloud::Plan.new

    assert_equal plan.id, SakuraCloud::Plan::PLANS.first[:id]
    assert_equal plan.name, SakuraCloud::Plan::PLANS.first[:name]
    assert_equal plan.cpu, SakuraCloud::Plan::PLANS.first[:cpu]
    assert_equal plan.availability, SakuraCloud::Plan::PLANS.first[:availability]
  end

  def test_with_my_plan
    plan = SakuraCloud::Plan.new id: 3

    assert_equal plan.id, SakuraCloud::Plan::PLANS[2][:id]
    assert_equal plan.name, SakuraCloud::Plan::PLANS[2][:name]
    assert_equal plan.cpu, SakuraCloud::Plan::PLANS[2][:cpu]
    assert_equal plan.availability, SakuraCloud::Plan::PLANS[2][:availability]
  end

  def test_raise_no_plan_error
    assert_raises SakuraCloud::NoServerPlanError do
      SakuraCloud::Plan.new id: 100
    end
  end
end

