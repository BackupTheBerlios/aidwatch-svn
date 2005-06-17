require File.dirname(__FILE__) + '/../test_helper'
require 'wavedb_utils'

class UserTest < Test::Unit::TestCase
  include WaveDBUtils
  fixtures :users

  def test_emailstr_sort
   emailstr = "johndoe,janedoe,zztop,jandoe"
   result = entries(emailstr)
   assert result.shift == "janedoe", "janedoe needs to be on top!"
   assert result.pop == "zztop", "zztop needs to be buried!"
   assert isInList?(emailstr,"johndoe"), "Where the heck is johndoe?"
   newlist = makeList(result)
   assert isInList?(newlist,"johndoe"), "Where the heck is johndoe?"
   assert !isInList?(newlist,"janedoe"), "janedoe was not invited!"
   newlist = addToList(newlist,"janedoe")
   assert isInList?(newlist,"janedoe"), "janedoe ain't here!"
   newlist = removeFromList(newlist,"janedoe")
   assert !isInList?(newlist,"janedoe"), "janedoe was booted!"
  end
    
  def test_auth
    
#    assert_equal  @bob, User.authenticate("bob", "test")    
#    assert_nil    User.authenticate("nonbob", "test")
    
  end


  def test_passwordchange
        
#    @longbob.change_password("nonbobpasswd")
#    assert_equal @longbob, User.authenticate("longbob", "nonbobpasswd")
#    assert_nil   User.authenticate("longbob", "longtest")
#    @longbob.change_password("longtest")
#    assert_equal @longbob, User.authenticate("longbob", "longtest")
#    assert_nil   User.authenticate("longbob", "nonbobpasswd")
        
  end
  
  def test_disallowed_passwords
    
#    u = User.new    
#    u.login = "nonbob"
#
#    u.password = u.password_confirmation = "tiny"
#    assert !u.save     
#    assert u.errors.invalid?('password')
#
#    u.password = u.password_confirmation = "hugehugehugehugehugehugehugehugehugehugehugehugehugehugehugehugehugehugehugehugehugehugehugehugehugehugehugehugehugehugehugehugehugehugehugehugehugehugehugehugehugehugehuge"
#    assert !u.save     
#    assert u.errors.invalid?('password')
        
#    u.password = u.password_confirmation = ""
#    assert !u.save    
#    assert u.errors.invalid?('password')
#        
#    u.password = u.password_confirmation = "bobs_secure_password"
#    assert u.save     
#    assert u.errors.empty?
#        
  end
  
  def test_bad_logins

#    u = User.new  
#    u.password = u.password_confirmation = "bobs_secure_password"
#
#    u.login = "tiny"
#    assert !u.save     
#    assert u.errors.invalid?('login')
#    
#    u.login = "hugebobhugebobhugebobhugebobhugebobhugebobhugebobhugebobhugebobhugebobhugebobhugebobhugebobhugebobhugebobhugebobhugebobhugebobhugebobhugebobhugebobhugebobhugebobhugebobhugebobhugebobhug"
#    assert !u.save     
#    assert u.errors.invalid?('login')
#
#    u.login = ""
#    assert !u.save
#    assert u.errors.invalid?('login')
#
#    u.login = "okbob"
#    assert u.save  
#    assert u.errors.empty?
#      
  end


  def test_collision
#    u = User.new
#    u.login      = "existingbob"
#    u.password = u.password_confirmation = "bobs_secure_password"
#    assert !u.save
  end


  def test_create
#    u = User.new
#    u.login      = "nonexistingbob"
#    u.password = u.password_confirmation = "bobs_secure_password"
#      
#    assert u.save  
#    
  end
  
  def test_sha1
#    u = User.new
#    u.login      = "nonexistingbob"
#    u.password = u.password_confirmation = "bobs_secure_password"
#    assert u.save
#        
#    assert_equal '98740ff87bade6d895010bceebbd9f718e7856bb', u.password
#    
  end

  
end
