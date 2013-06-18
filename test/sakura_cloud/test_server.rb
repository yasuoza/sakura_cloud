require 'test_helper'

class SakuraCloud::ServerAPITest < MiniTest::Unit::TestCase
  include StubJsonResponse
  include StubAPIRequest

  def setup
    unless defined?(SakuraCloud::API_KEY) && defined?(SakuraCloud::API_SECRET)
      stub_api_key_secret!
    end

    stub_api_request!(:get, '/product/server')
    stub_api_request!(:get, '/product/internet')
    stub_api_request!(:get, '/product/disk')

    require 'sakura_cloud'
    require 'sakura_cloud/server'
  end

  def test_list_servers
    stub_api_request!(:get, '/server')

    servers = SakuraCloud::Server.all

    assert_equal servers.first.id, "112500052062"
    assert_equal servers.first.name, "saba1"
    assert_equal servers.first.description, ""
  end

  def test_init_with_mininum_plan
    server = SakuraCloud::Server.new

    assert_equal server.plan.id, SakuraCloud::Server::Plan.all.first.id
    assert_equal server.plan.name, SakuraCloud::Server::Plan.all.first.name
    assert_equal server.plan.cpu, SakuraCloud::Server::Plan.all.first.cpu
    assert_equal server.plan.availability, SakuraCloud::Server::Plan.all.first.availability
  end

  def test_init_with_my_plan
    server = SakuraCloud::Server.new(plan_id: 3)

    assert_equal server.plan.id, SakuraCloud::Server::Plan.all[2].id
    assert_equal server.plan.name, SakuraCloud::Server::Plan.all[2].name
    assert_equal server.plan.cpu, SakuraCloud::Server::Plan.all[2].cpu
    assert_equal server.plan.availability, SakuraCloud::Server::Plan.all[2].availability
  end

  def test_init_with_one_of_server_plan
    server = SakuraCloud::Server.new(plan_id: SakuraCloud::Server::Plan.all[3].id)

    assert_equal server.plan.id, SakuraCloud::Server::Plan.all[3].id
    assert_equal server.plan.name, SakuraCloud::Server::Plan.all[3].name
    assert_equal server.plan.cpu, SakuraCloud::Server::Plan.all[3].cpu
    assert_equal server.plan.availability, SakuraCloud::Server::Plan.all[3].availability
  end

  def test_raise_no_plan_error
    assert_raises SakuraCloud::Server::NoPlanError do
      SakuraCloud::Server.new plan_id: 100
    end
  end
end
