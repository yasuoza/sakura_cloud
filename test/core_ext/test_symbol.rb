require 'test_helper'
require 'core_ext/string'
require 'core_ext/symbol'

class SymbolExtensionTest < MiniTest::Unit::TestCase
  def test_symbol_underscore
    assert_equal :ID.underscore,          :id
    assert_equal :CPU.underscore,         :cpu
    assert_equal :MemoryMB.underscore,    :memory_mb
    assert_equal :ServerPlans.underscore, :server_plans
  end

  def test_symbol_camelize
    assert_equal :id.camelize,            :ID
    assert_equal :cpu.camelize,           :CPU
    assert_equal :icon.camelize,          :Icon
    assert_equal :memory_mb.camelize,     :MemoryMB
    assert_equal :size_mb.camelize,       :SizeMB
    assert_equal :service_class.camelize, :ServiceClass
  end
end
