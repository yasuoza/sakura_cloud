require 'test_helper'

class SakuraCloud::ServerAPITest < MiniTest::Test
  include StubJsonResponse
  include StubAPIRequest

  def setup
    unless defined?(SakuraCloud::API_KEY) && defined?(SakuraCloud::API_SECRET)
      stub_api_key_secret!
    end

    stub_api_request!(:get, '/zone')
    stub_api_request!(:get, '/product/server')
    stub_api_request!(:get, '/product/internet')
    stub_api_request!(:get, '/product/disk')

    require 'sakura_cloud'
  end

  def test_list_servers
    stub_api_request!(:get, '/server')

    servers = SakuraCloud::Server.all

    assert_equal servers.first.id, "112500052062"
    assert_equal servers.first.name, "saba1"
    assert_equal servers.first.description, ""
    assert       !servers.first.new_record?
  end

  def test_list_servers_with_query_params
    stub_api_request!(:get, '/server')
    stub_api_request!(:get, '/server?%7B%22Count%22:1,%22From%22:1%7D') #=> /servers?{"Count":1,"From":1}

    all_servers = SakuraCloud::Server.all
    queried_servers = SakuraCloud::Server.all(count: 1, from: 1)

    assert_equal queried_servers.count, 1
    assert_equal queried_servers.first.id, all_servers[1].id
    assert_equal queried_servers.first.name, all_servers[1].name
    assert       !queried_servers.first.new_record?
  end

  def test_init_with_mininum_plan
    server = SakuraCloud::Server.new(name: 'minimum server')

    assert_equal server.plan.id, SakuraCloud::Server::Plan.all.first.id
    assert_equal server.plan.name, SakuraCloud::Server::Plan.all.first.name
    assert_equal server.plan.cpu, SakuraCloud::Server::Plan.all.first.cpu
    assert_equal server.plan.availability, SakuraCloud::Server::Plan.all.first.availability
    assert_equal server.name, 'minimum server'
    assert       server.new_record?
  end

  def test_init_with_my_plan
    server = SakuraCloud::Server.new(plan_id: 3, name: 'my server')

    assert_equal server.plan.id, SakuraCloud::Server::Plan.all[2].id
    assert_equal server.plan.name, SakuraCloud::Server::Plan.all[2].name
    assert_equal server.plan.cpu, SakuraCloud::Server::Plan.all[2].cpu
    assert_equal server.plan.availability, SakuraCloud::Server::Plan.all[2].availability
    assert_equal server.name, 'my server'
    assert       server.new_record?
  end

  def test_init_with_one_of_server_plan
    server = SakuraCloud::Server.new(plan_id: SakuraCloud::Server::Plan.all[3].id, name: 'third server')

    assert_equal server.plan.id, SakuraCloud::Server::Plan.all[3].id
    assert_equal server.plan.name, SakuraCloud::Server::Plan.all[3].name
    assert_equal server.plan.cpu, SakuraCloud::Server::Plan.all[3].cpu
    assert_equal server.plan.availability, SakuraCloud::Server::Plan.all[3].availability
    assert_equal server.name, 'third server'
    assert       server.new_record?
  end

  def test_assign_server_name
    server = SakuraCloud::Server.new
    server.name = 'my server'

    assert_equal server.name, 'my server'
    assert       server.new_record?
  end
end
