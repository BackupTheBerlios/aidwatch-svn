require File.dirname(__FILE__) + '/../test_helper'

class WatchTest < Test::Unit::TestCase
  fixtures :watches

  def setup
    @watch = Watch.find(1)
  end

  # Replace this with your real tests.
  def test_truth
    assert_kind_of Watch,  @watch
  end
end
