require File.dirname(__FILE__) + '/../test_helper'
require 'supply_controller'

# Re-raise errors caught by the controller.
class SupplyController; def rescue_action(e) raise e end; end

class SupplyControllerTest < Test::Unit::TestCase
  fixtures :supplies

  def setup
#    @controller = SupplyController.new
#    @request, @response = ActionController::TestRequest.new, ActionController::TestResponse.new
  end

  def test_index
#    process :index
#    assert_rendered_file 'list'
  end

  def test_list
#    process :list
#    assert_rendered_file 'list'
#    assert_template_has 'supplies'
  end

  def test_show
#    process :show, 'id' => 1
#    assert_rendered_file 'show'
#    assert_template_has 'supply'
#    assert_valid_record 'supply'
  end

  def test_new
#    process :new
#    assert_rendered_file 'new'
#    assert_template_has 'supply'
  end

  def test_create
#    num_supplies = Supply.find_all.size

#    process :create, 'supply' => { }
#    assert_redirected_to :action => 'list'

#    assert_equal num_supplies + 1, Supply.find_all.size
  end

  def test_edit
#    process :edit, 'id' => 1
#    assert_rendered_file 'edit'
#    assert_template_has 'supply'
#    assert_valid_record 'supply'
  end

  def test_update
#    process :update, 'supply' => { 'id' => 1 }
#    assert_redirected_to :action => 'show', :id => 1
  end

  def test_destroy
#    assert_not_nil Supply.find(1)

#    process :destroy, 'id' => 1
#    assert_redirected_to :action => 'list'

#    assert_raise(ActiveRecord::RecordNotFound) {
#      supply = Supply.find(1)
#    }
  end
end
