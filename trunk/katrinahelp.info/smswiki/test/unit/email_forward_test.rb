require File.dirname(__FILE__) + '/../test_helper'

class EmailForwardTest < Test::Unit::TestCase
  fixtures :email_forwards

  def setup
    @email_forward = EmailForward.find(1)
  end

  # Replace this with your real tests.
  def test_truth
    assert_kind_of EmailForward,  @email_forward
  end
end
