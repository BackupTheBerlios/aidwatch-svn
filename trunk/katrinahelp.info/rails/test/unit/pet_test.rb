require File.dirname(__FILE__) + '/../test_helper'

class PetTest < Test::Unit::TestCase
  fixtures :pets

  def setup
    @pet = Pet.find(1)
  end

  # Replace this with your real tests.
  def test_truth
    assert_kind_of Pet,  @pet
  end
end
