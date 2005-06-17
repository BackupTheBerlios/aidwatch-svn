require 'digest/sha1'
require 'wavedb_utils'

# this model expects a certain database layout and its based on the name/login pattern. 
class User < ActiveRecord::Base
  include WaveDBUtils

  def self.authenticate(login, pass)
    find_first(["login = ? AND password = ?", login, sha1(pass)])
  end  

  def hasVerifiedEmail?() veremail && veremail =~ /\w/ end
  def change_password(pass)
    update_attribute "password", self.class.sha1(pass)
  end

  # user bit assignments:
  # Bit 0 is on the far right, LSB
  # Bit 0    isPhoneWriter
  # Bit 1    isManager
  # Bit 2    isAdmin
  # Bit 3    isEmailVerified
  # Bit 4    isLocationWriter
  def isEmailVerified?()
    flags & 16 != 0
  end

  def setEmailVerified()
    self.flags |= 16
  end

  def resetEmailVerified()
    self.flags &= ~16
  end

  def isLocationWriter?()
    flags & 32 != 0
  end

  def setLocationWriter()
    self.flags |= 32
  end

  def resetLocationWriter()
    self.flags &= ~32
  end

  def isAnyAdmin?()
    self.adminp.size > 0
  end

  def isAnyManager?()
    self.managep.size > 0
  end
  def canSetRead?(cname)
    isManager?(cname) || isAdmin?(cname)
  end

  def canSetWrite?(cname)
    isManager?(cname) || isAdmin?(cname)
  end

  def canSetManage?(cname)
    isAdmin?(cname)
  end

  def canSetAdmin?(cname)
    false
  end

  def isReader?(cname)
    return true if isInList?(self.readp,cname)
    return false
  end

  def isWriter?(cname)
    return true if isInList?(self.writep,cname)
    return false
  end

  def isManager?(cname)
    return true if isInList?(self.managep,cname)
    return false
  end

  def isAdmin?(cname)
    return true if isInList?(self.adminp,cname)
    return false
  end

  def htmlName()
    hname = login.to_s.clone
#    hname = "<i>#{hname}</i>" if isWriter?
#    hname = "<b>#{hname}</b>" if isManager?
#    hname = "[#{hname}]" if isAdmin?
    hname
  end

  protected

  def self.sha1(pass)
    Digest::SHA1.hexdigest("change-me--#{pass}--")
  end
    
  before_create :crypt_password
  
  def crypt_password
    write_attribute("password", self.class.sha1(password)) if password == @password_confirmation
  end

  validates_length_of :password, :login, :within => 5..40
  validates_presence_of :password, :login
  validates_uniqueness_of :login, :on => :create
  validates_uniqueness_of :email, :on => :create
  validates_confirmation_of :password, :on => :create
  validates_format_of :email, :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/, :on => :save
end
