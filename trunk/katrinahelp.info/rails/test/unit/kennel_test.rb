require File.dirname(__FILE__) + '/../test_helper'

class KennelTest < Test::Unit::TestCase
  fixtures :kennels

  def setup
    @kennel = Kennel.find(1)
  end

  # Replace this with your real tests.
  def test_truth
    assert_kind_of Kennel,  @kennel
  end
end
