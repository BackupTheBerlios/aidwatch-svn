require File.dirname(__FILE__) + '/../test_helper'

class RecipeTest < Test::Unit::TestCase
  fixtures :recipes

  def setup
    @recipe = Recipe.find(1)
  end

  # Replace this with your real tests.
  def test_truth
    assert_kind_of Recipe,  @recipe
  end
end
