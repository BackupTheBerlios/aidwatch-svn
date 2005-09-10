require File.dirname(__FILE__) + '/../test_helper'
require 'volunteer_controller'
require 'wavedb_controller'

# Re-raise errors caught by the controller.
class VolunteerController; def rescue_action(e) raise e end; end

class VolunteerControllerTest < Test::Unit::TestCase
  include LoginHelper
  fixtures :volunteers, :locations, :users

  # Replace this with your real tests.
  def setup
    @controller = VolunteerController.new
    @request, @response = ActionController::TestRequest.new, ActionController::TestResponse.new
    @request.host = "localhost"
#    @request.parameters["controller"] = "volunteer"
#    breakpoint "here is setup in volunteer with #{@controller}"
  end

  def test_truth
    assert true
  end

  def test_volunteer_list
    #positive case
    loginUser("janedoe","password")
    process :list
    assert @response.body =~ /volunteers/i, @response.body

    # negative case
    loginUser("janedoe","badpassword")
    process :list
    assert @response.body =~ /Sorry/i, @response.body
  end

  def test_show
    loginUser("janedoe","password")
    process :show, 'id' => 1
    assert @response.body =~ /Jane/, "Error, lead developer missing!"
  end


  def test_new
    process :new
    assert_rendered_file 'new'
    assert_template_has 'volunteer'
  end

#  def test_create
#    num_volunteers = Volunteer.find_all.size
#
#    process :create, 'volunteer' => { }
#    assert_redirected_to :action => 'list'
#
#    assert_equal num_volunteers + 1, Volunteer.find_all.size
#  end

#  def test_edit
#    process :edit, 'id' => 1
#    assert_rendered_file 'edit'
#    assert_template_has 'volunteer'
#    assert_valid_record 'volunteer'
#  end

#  def test_update
#    process :update, 'volunteer' => { 'id' => 1 }
#    assert_redirected_to :action => 'show', :id => 1
#  end

#  def test_destroy
#    assert_not_nil Volunteer.find(1)

#    process :destroy, 'id' => 1
#    assert_redirected_to :action => 'list'

#    assert_raise(ActiveRecord::RecordNotFound) {
#      volunteer = Volunteer.find(1)
#    }
#  end
end
