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
  end

  def test_init_with_mininum_ssd_plan
    disk = SakuraCloud::Disk.new(:type => :ssd)

    assert_equal disk.plan.index, 0
    assert_equal disk.plan.type, :ssd
    assert_equal disk.plan.size, SakuraCloud::Disk::Plan.all[0].size

    assert_equal disk.type, :ssd
    assert_equal disk.size, SakuraCloud::Disk::Plan.all[0].size
    assert_equal disk.size_mb, SakuraCloud::Disk::Plan.all[0].size_mb
  end

  def test_init_with_minimum_hdd_plan
    disk = SakuraCloud::Disk.new(:type => :hdd)

    assert_equal disk.plan.index, 1
    assert_equal disk.plan.type, :hdd
    assert_equal disk.plan.size, SakuraCloud::Disk::Plan.all.select {|p| p.type == :hdd}.first.size

    assert_equal disk.type, :hdd
    assert_equal disk.size, SakuraCloud::Disk::Plan.all.select {|p| p.type == :hdd}.first.size
    assert_equal disk.size_mb, SakuraCloud::Disk::Plan.all.select {|p| p.type == :hdd}.first.size_mb
  end

  def test_init_with_custom_plan
    disk = SakuraCloud::Disk.new(:type => :ssd, :size => 100)

    assert_equal disk.plan.index, 0
    assert_equal disk.plan.type, :ssd
    assert_equal disk.plan.size, 100

    assert_equal disk.type, :ssd
    assert_equal disk.size, 100
    assert_equal disk.size_mb, 2 ** 10 * 100
  end

  def test_assign_disk_name
    disk = SakuraCloud::Disk.new
    disk.name = 'my disk'

    assert_equal disk.name, 'my disk'
  end

  def test_raise_no_plan_error_for_type
    assert_raises SakuraCloud::Disk::NoPlanError do
      SakuraCloud::Disk.new(:type => :ssh)
    end
  end

  def test_raise_no_plan_error_for_size
    assert_raises SakuraCloud::Disk::NoPlanError do
      SakuraCloud::Disk.new(:type => :ssd, :size => 150)
    end
  end

  def test_raise_on_save
    disk = SakuraCloud::Disk.new
    assert_raises ArgumentError do
      disk.save
    end
  end

  def test_nothing_raised_on_save
    disk = SakuraCloud::Disk.new
    disk.name = 'special disk'
    disk.save
  end
end
