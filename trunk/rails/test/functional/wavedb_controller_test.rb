require File.dirname(__FILE__) + '/../test_helper'
require 'wavedb_controller'

# Raise errors beyond the default web-based presentation
class WavedbController; def rescue_action(e) raise e end; end

class WavedbControllerTest < Test::Unit::TestCase
  include LoginHelper
  
  fixtures :users
  
  def setup
    @controller = WavedbController.new
    @request, @response = ActionController::TestRequest.new, ActionController::TestResponse.new
    @request.host = "localhost"
  end
  
  def test_signup
    @request.session['return-to'] = "/wavedb/welcome"
    post :signup, "user" => { "login" => "newbob", "password" => "newpassword", "password_confirmation" => "newpassword" }
    loginUser("newbob","newpassword")
    assert_session_has "user"
    @request.session['user'].login == "newbob"
  end

  def test_bad_signup
#    @request.session['return-to'] = "/bogus/location"
#
#    post :signup, "user" => { "login" => "newbob", "password" => "newpassword", "password_confirmation" => "wrong" }
#    assert_invalid_column_on_record "user", "password"
#    assert_success
#    
#    post :signup, "user" => { "login" => "yo", "password" => "newpassword", "password_confirmation" => "newpassword" }
#    assert_invalid_column_on_record "user", "login"
#    assert_success
#
#    post :signup, "user" => { "login" => "yo", "password" => "newpassword", "password_confirmation" => "wrong" }
#    assert_invalid_column_on_record "user", ["login", "password"]
#    assert_success
  end

  def test_invalid_login
    loginUser("bob","not_correct")
     
    @request.session['user'].login == "guest"
    
#    assert_template_has :message
  end
  
  def test_login_logoff

    post :login, "user_login" => "janedoe", "user_password" => "password", "controller" => "wavedb"
    assert_session_has "user"

    get :logout
    @request.session['user'].login == "guest"

  end
  
end
