require File.dirname(__FILE__) + '/../test_helper'
require 'phonenum_controller'

# Re-raise errors caught by the controller.
class PhonenumController; def rescue_action(e) raise e end; end

class PhonenumControllerTest < Test::Unit::TestCase
  include LoginHelper
  fixtures :phonenums
  fixtures :users

  def setup
    @controller = PhonenumController.new
    @request, @response = ActionController::TestRequest.new, ActionController::TestResponse.new
  end

  def test_index
    process :index
    assert_rendered_file 'list'
  end

  def test_list
    process :list
    assert_rendered_file 'list'
  end

  def test_show
    process :show, 'id' => 1
    assert_rendered_file 'show'
    assert_template_has 'phonenum'
    assert_valid_record 'phonenum'
    assert @response.body =~ /AID-India/, "AID-India ain't there!"
    assert @response.body !~ /Michael Jackson/, "What's Michael doing here?"
  end

#  def test_search
#    post :namesearchsub, "searchterm" => "AID"
#    assert @response.body =~ /AID-India/, "AID-India ain't there!"
#    assert @response.body !~ /Michael Jackson/, "What's Michael doing here?"
#  end

  def test_new
    process :new
    assert_rendered_file 'new'
    assert_template_has 'phonenum'
  end

  def test_create
#    num_phonenums = Phonenum.find_all.size

#    process :create, 'phonenum' => { }
#    assert_redirected_to :action => 'list'

#    assert_equal num_phonenums + 1, Phonenum.find_all.size
  end

  def test_edit
    loginUser("janedoe","password")
    post :edit, 'id' => 1
    assert @response.body =~ /AID-India/, "AID-India ain't there!"
  end

  def test_update
    loginUser("janedoe","password")
    process :show, 'id' => 1
    assert @response.body =~ /notes/, "notes are gone"
    process :update, 'phonenum' => { 'id' => 1, 'notes' => 'hey, I am updated' }
   # assert_redirected_to :action => 'show', :id => 1
    get :show, 'id' => 1
   puts "RESPONSE: #{@response.body}"
    assert @response.body =~ /updated/, "AID-India didn't update!"
  end

  def test_rdestroy
    assert_not_nil Phonenum.find(1)

    loginUser("guest","tsunami")
    process :destroy, 'id' => 1
    process :list
    assert_not_nil Phonenum.find(1)
  end

  def test_destroy
    assert_not_nil Phonenum.find(3)

    loginUser("janedoe","password")
    process :destroy, 'id' => 3
#    assert_redirected_to :action => 'list'
    process :list

    assert_raise(ActiveRecord::RecordNotFound) {
      phonenum = Phonenum.find(3)
    }
  end
end
