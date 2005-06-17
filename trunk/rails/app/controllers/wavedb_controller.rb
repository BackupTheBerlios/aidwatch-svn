require 'ncd_util'
require 'notifier'

class WavedbController < ApplicationController
  model   :user
  model   :approx
  layout  'wavedb'

  before_filter :login_required

  def search
    @limit = 100
    st = @params['searchterm']
    if st
			@aps = NCDUtil::searchApprox("Words", "val", st, @limit)
    else
      @aps = nil
    end
  end

  def sendVolunteerEmail
    login = @user.login
    name = @user.login
    email = @user.veremail
    volid = @params['volid']
    bodytxt = @params['bodytxt']
    subject = @params['subject']
    vol = Volunteer.find(volid)
    volname = vol.name
    volemail = vol.email
    Notifier.deliver_request_help(login, name, email, volname, volemail, subject, bodytxt)
    @msg = "Your message has been sent."
  end

  def sendVerifyTicket
    secretpw = 'goober15387'
    if @user.login == 'guest'
      @msg = "Sorry, guest not allowed to verify email."
      return
    end
    em = @user.email
    unless em =~ /[a-zA-Z0-9]/
      @msg = "No valid email address on file; please use account settings."
      return
    end
    username = @user.login
    inpstr = "#{secretpw}:#{username}:#{em}"
    pvt = doHashFunc(inpstr)
    Notifier.deliver_verify_email(username, em, pvt)
    @msg = "Sent verification email to #{em}"
  end
  def processVerifyTicket
    secretpw = 'goober15387'
    h = @params['pvt'] || '0'
    em = @params['verem'] || 'notit'
    username = @params['login'] || 'nothim'
    if username == 'guest'
      @msg = "Sorry, guest not allowed to verify email."
      return
    end
    vuser = User.find_all(["login = ?", username])
    unless vuser.size == 1
      @msg = "Bad login #{username}"
      return
    end
    vuser = vuser[0]
    unless vuser.email == em
      @msg = "Bad email #{em}, but #{vuser.email} is on file."
      return
    end
    inpstr = "#{secretpw}:#{username}:#{em}"
    needcode = doHashFunc(inpstr)
    unless h == needcode
      @msg = "Bad person! bad! bad!"
      return
    end
    vuser.veremail = em
    vuser.save
    @msg = "Email address #{em} verified, thank you."
  end
  def accountSettings
  end

  def updateUserEmail
    @messages = [ ]
    @user.email = alGrabParams()['user']['email']
    if @user.save
      @messages << "***Email successfully updated"
      flash['notice'] = 'User Email was successfully updated.'
      render_action 'accountSettings'
    else
      render_action 'accountSettings'
    end
  end

  def listUsers
    @userlist = User.find_all().sort() { |a,b| a.login.downcase <=> b.login.downcase }
  end

  def adminCon
  end

  def manageUserPriv
    @cname = @params['privCon']
    @users = User.find_all().sort() { |a,b| a.login.downcase <=> b.login.downcase }
  end

  def processPriv
    @messages = [ ]
    @cname = @params['privCon']
    fail "Invalid Controller: #{@cname}" unless WaveDBUtils::validControllers.include?(@cname)
    inputform = @params['privForm']
    @users = User.find_all()
    @users.each { |u|
      ['readp', 'writep', 'managep', 'adminp'].each { |chkname|
        oldperm = nil
        iserror = nil
        userinp = inputform ? inputform[u.id.to_s] : nil
        newperm = userinp && userinp.has_key?(chkname)
        iserror, oldperm = case chkname
          when 'readp'
            [!@user.canSetRead?(@cname), u.isReader?(@cname)]
          when 'writep'
            [!@user.canSetWrite?(@cname), u.isWriter?(@cname)]
          when 'managep'
            [!@user.canSetManage?(@cname), u.isManager?(@cname)]
          when 'adminp'
            [!@user.canSetAdmin?(@cname), u.isAdmin?(@cname)]
          else
            @messages << "***Error, cannot set fieldname #{chkname} for #{@cname}"
            [true,nil]
        end
        unless iserror
          if oldperm ^ newperm
            if newperm
              eval "u.#{chkname} = addToList(u.#{chkname}, '#{@cname}')"
            else
              eval "u.#{chkname} = removeFromList(u.#{chkname}, '#{@cname}')"
            end
            u.save
          end
        end
      }
    }
    if @messages.size > 0
      render_action 'manageUserPriv'
    else
      render_action 'adminCon'
    end

  end

  def login
    message = [ ]
    message.push @params['message'] if @params['message']
    case @request.method
      when :post
        if @session['user'] = User.authenticate(@params['user_login'], @params['user_password'])
          @user = @session['user']
          flash['notice']  = "Login successful"
          redirect_back_or_default :action => "welcome"
        else
          @login    = @params['user_login']
          message.push "***Login unsuccessful"
      end
    end
    @message = message.join("<br>")
    @user ||= User.authenticate('guest','tsunami')
    @session['user'] ||= @user
  end
  
  def signup
    case @request.method
      when :post
        @user = User.new(@params['user'])
        if @user.save      
          @session['user'] = User.authenticate(@user.login, @params['user']['password'])
          flash['notice']  = "Signup successful"
          redirect_back_or_default :action => "welcome"          
        end
      when :get
        @user = User.new
    end
  end  
  
#  def delete
#   if @session['user'] && @session['user'].isAdmin?
#      if @params['id']
#        @user = User.find(@params['id'])
#        @user.destroy
#			end
#      redirect_back_or_default :action => "welcome"
#   else
#      @message = "Sorry, admins only"
#      render "wavedb/login" 
#   end
#  end  
    
  def logout
    @user = User.authenticate('guest','tsunami')
    @session['user'] = @user
  end
    
  def welcome
  end
  
end
