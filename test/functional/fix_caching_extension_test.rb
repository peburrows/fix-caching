require File.dirname(__FILE__) + '/../test_helper'

class FixCachingExtensionTest < Test::Unit::TestCase
  
  # Replace this with your real tests.
  def test_this_extension
    flunk
  end
  
  def test_initialization
    assert_equal File.join(File.expand_path(RAILS_ROOT), 'vendor', 'extensions', 'fix_caching'), FixCachingExtension.root
    assert_equal 'Fix Caching', FixCachingExtension.extension_name
  end
  
end
