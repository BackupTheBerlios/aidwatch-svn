require File.dirname(__FILE__) + '/../test_helper'
require 'email_forwards_controller'

# Re-raise errors caught by the controller.
class EmailForwardsController; def rescue_action(e) raise e end; end

class EmailForwardsControllerTest < Test::Unit::TestCase
  fixtures :email_forwards

  def setup
    @controller = EmailForwardsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_index
    get :index
    assert_response :success
    assert_template 'list'
  end

  def test_list
    get :list

    assert_response :success
    assert_template 'list'

    assert_not_nil assigns(:email_forwards)
  end

  def test_show
    get :show, :id => 1

    assert_response :success
    assert_template 'show'

    assert_not_nil assigns(:email_forward)
    assert assigns(:email_forward).valid?
  end

  def test_new
    get :new

    assert_response :success
    assert_template 'new'

    assert_not_nil assigns(:email_forward)
  end

  def test_create
    num_email_forwards = EmailForward.count

    post :create, :email_forward => {}

    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_equal num_email_forwards + 1, EmailForward.count
  end

  def test_edit
    get :edit, :id => 1

    assert_response :success
    assert_template 'edit'

    assert_not_nil assigns(:email_forward)
    assert assigns(:email_forward).valid?
  end

  def test_update
    post :update, :id => 1
    assert_response :redirect
    assert_redirected_to :action => 'show', :id => 1
  end

  def test_destroy
    assert_not_nil EmailForward.find(1)

    post :destroy, :id => 1
    assert_response :redirect
    assert_redirected_to :action => 'list'

    assert_raise(ActiveRecord::RecordNotFound) {
      EmailForward.find(1)
    }
  end
end
