require File.dirname(__FILE__) + '/../test_helper'
require 'disease_controller'

# Re-raise errors caught by the controller.
class DiseaseController; def rescue_action(e) raise e end; end

class DiseaseControllerTest < Test::Unit::TestCase
  fixtures :diseases

  def setup
    @controller = DiseaseController.new
    @request, @response = ActionController::TestRequest.new, ActionController::TestResponse.new
  end

#  def test_index
#    process :index
#    assert_rendered_file 'list'
#  end
#
#  def test_list
#    process :list
#    assert_rendered_file 'list'
#    assert_template_has 'diseases'
#  end
#
#  def test_show
#    process :show, 'id' => 1
#    assert_rendered_file 'show'
#    assert_template_has 'disease'
#    assert_valid_record 'disease'
#  end
#
#  def test_new
#    process :new
#    assert_rendered_file 'new'
#    assert_template_has 'disease'
#  end
#
#  def test_create
#    num_diseases = Disease.find_all.size
#
#    process :create, 'disease' => { }
#    assert_redirected_to :action => 'list'
#
#    assert_equal num_diseases + 1, Disease.find_all.size
#  end
#
#  def test_edit
#    process :edit, 'id' => 1
#    assert_rendered_file 'edit'
#    assert_template_has 'disease'
#    assert_valid_record 'disease'
#  end
#
#  def test_update
#    process :update, 'disease' => { 'id' => 1 }
#    assert_redirected_to :action => 'show', :id => 1
#  end
#
#  def test_destroy
#    assert_not_nil Disease.find(1)
#
#    process :destroy, 'id' => 1
#    assert_redirected_to :action => 'list'
#
#    assert_raise(ActiveRecord::RecordNotFound) {
#      disease = Disease.find(1)
#    }
#  end
#end
