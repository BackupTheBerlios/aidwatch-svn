require File.dirname(__FILE__) + '/../test_helper'
require 'person_controller'

# Re-raise errors caught by the controller.
class PersonController; def rescue_action(e) raise e end; end

class PersonControllerTest < Test::Unit::TestCase
  fixtures :people

  def setup
#    @controller = PersonController.new
#    @request, @response = ActionController::TestRequest.new, ActionController::TestResponse.new
  end

  def test_index
#    process :index
#    assert_rendered_file 'list'
  end

  def test_list
#    process :list
#    assert_rendered_file 'list'
#    assert_template_has 'people'
  end

  def test_show
#    process :show, 'id' => 1
#    assert_rendered_file 'show'
#    assert_template_has 'person'
#    assert_valid_record 'person'
  end

  def test_new
#    process :new
#    assert_rendered_file 'new'
#    assert_template_has 'person'
  end

  def test_create
#    num_people = Person.find_all.size
#
#    process :create, 'person' => { }
#    assert_redirected_to :action => 'list'
#
#    assert_equal num_people + 1, Person.find_all.size
  end

  def test_edit
#    process :edit, 'id' => 1
#    assert_rendered_file 'edit'
#    assert_template_has 'person'
#    assert_valid_record 'person'
  end

  def test_update
#    process :update, 'person' => { 'id' => 1 }
#    assert_redirected_to :action => 'show', :id => 1
  end

  def test_destroy
#    assert_not_nil Person.find(1)

#    process :destroy, 'id' => 1
#    assert_redirected_to :action => 'list'

#    assert_raise(ActiveRecord::RecordNotFound) {
#      person = Person.find(1)
#    }
  end
end
