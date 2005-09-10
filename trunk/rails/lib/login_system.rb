require 'digest/md5'
require_dependency "user"

module LoginSystem
  @@MLVL_SAFE = 0
  @@MLVL_READ = 1
  @@MLVL_WRITE = 2
  @@MLVL_MANAGE = 3
  @@MLVL_ADMIN = 4

  @@ML = {
         'disease/adjustStatusOrLocation' => @@MLVL_SAFE,
         'disease/choseItem' => @@MLVL_SAFE,
         'disease/create' => @@MLVL_SAFE,
         'disease/destroy' => @@MLVL_WRITE,
         'disease/diseaseSearch' => @@MLVL_SAFE,
         'disease/edit' => @@MLVL_WRITE,
         'disease/list' => @@MLVL_SAFE,
         'disease/new' => @@MLVL_SAFE,
         'disease/show' => @@MLVL_SAFE,
         'disease/showDiseaseFromSession' => @@MLVL_SAFE,
         'disease/update' => @@MLVL_WRITE,
         'location/create' => @@MLVL_WRITE,
         'location/destroy' => @@MLVL_WRITE,
         'location/doLocSet' => @@MLVL_SAFE,
         'location/goodLocSet' => @@MLVL_SAFE,
         'location/index' => @@MLVL_SAFE,
         'location/new' => @@MLVL_WRITE,
         'location/show' => @@MLVL_SAFE,
         'location/testStructure' => @@MLVL_ADMIN,
         'location/update' => @@MLVL_WRITE,
         'location/verifyParm' => @@MLVL_SAFE,
         'person/adjustStatusOrLocation' => @@MLVL_SAFE,
         'person/addToWatchList' => @@MLVL_SAFE,
         'person/choseItem' => @@MLVL_SAFE,
         'person/create' => @@MLVL_SAFE,
         'person/destroy' => @@MLVL_WRITE,
         'person/doPrevPage' => @@MLVL_SAFE,
         'person/doNextPage' => @@MLVL_SAFE,
         'person/doFirstPage' => @@MLVL_SAFE,
         'person/doLastPage' => @@MLVL_SAFE,
         'person/edit' => @@MLVL_WRITE,
         'person/index' => @@MLVL_WRITE,
         'person/list' => @@MLVL_SAFE,
         'person/new' => @@MLVL_SAFE,
         'person/personSearch' => @@MLVL_SAFE,
         'person/show' => @@MLVL_READ,
         'person/update' => @@MLVL_WRITE,
#         'person/showPersonFromSession' => @@MLVL_SAFE,
#         'phonenum/adjustStatusOrLocation' => @@MLVL_SAFE,
         'phonenum/choseItem' => @@MLVL_SAFE,
         'phonenum/create' => @@MLVL_SAFE,
         'phonenum/destroy' => @@MLVL_WRITE,
         'phonenum/doPrevPage' => @@MLVL_SAFE,
         'phonenum/doNextPage' => @@MLVL_SAFE,
         'phonenum/doFirstPage' => @@MLVL_SAFE,
         'phonenum/doLastPage' => @@MLVL_SAFE,
         'phonenum/edit' => @@MLVL_WRITE,
         'phonenum/index' => @@MLVL_SAFE,
         'phonenum/list' => @@MLVL_SAFE,
         'phonenum/namesearchsub' => @@MLVL_SAFE,
         'phonenum/new' => @@MLVL_SAFE,
         'phonenum/searchCat' => @@MLVL_SAFE,
         'phonenum/show' => @@MLVL_SAFE,
#         'phonenum/showPhonenum' => @@MLVL_SAFE,
         'phonenum/update' => @@MLVL_WRITE,
         'supply/choseItem' => @@MLVL_SAFE,
         'supply/create' => @@MLVL_SAFE,
         'supply/destroy' => @@MLVL_WRITE,
         'supply/doPrevPage' => @@MLVL_SAFE,
         'supply/doNextPage' => @@MLVL_SAFE,
         'supply/doFirstPage' => @@MLVL_SAFE,
         'supply/doLastPage' => @@MLVL_SAFE,
         'supply/edit' => @@MLVL_WRITE,
         'supply/index' => @@MLVL_SAFE,
         'supply/list' => @@MLVL_SAFE,
         'supply/new' => @@MLVL_SAFE,
         'supply/show' => @@MLVL_READ,
         'supply/update' => @@MLVL_WRITE,
         'volunteer/adjustStatusOrLocation' => @@MLVL_SAFE,
         'volunteer/choseItem' => @@MLVL_SAFE,
         'volunteer/create' => @@MLVL_SAFE,
         'volunteer/destroy' => @@MLVL_WRITE,
         'volunteer/doPrevPage' => @@MLVL_SAFE,
         'volunteer/doNextPage' => @@MLVL_SAFE,
         'volunteer/doFirstPage' => @@MLVL_SAFE,
         'volunteer/doLastPage' => @@MLVL_SAFE,
         'volunteer/edit' => @@MLVL_WRITE,
         'volunteer/index' => @@MLVL_READ,
         'volunteer/list' => @@MLVL_READ,
         'volunteer/new' => @@MLVL_SAFE,
         'volunteer/searchCat' => @@MLVL_READ,
         'volunteer/show' => @@MLVL_READ,
         'volunteer/showVolunteerFromSession' => @@MLVL_SAFE,
         'volunteer/update' => @@MLVL_WRITE,
         'volunteer/volunteerSearch' => @@MLVL_READ,
         'wavedb/accountSettings' => @@MLVL_SAFE,
         'wavedb/adminCon' => @@MLVL_SAFE,
         'wavedb/processVerifyTicket' => @@MLVL_SAFE,
         'wavedb/sendVerifyTicket' => @@MLVL_SAFE,
         'wavedb/sendVolunteerEmail' => @@MLVL_SAFE,
#         'wavedb/delete' => @@MLVL_SAFE,
         'wavedb/listUsers' => @@MLVL_SAFE,
         'wavedb/login' => @@MLVL_SAFE,
         'wavedb/logout' => @@MLVL_SAFE,
         'wavedb/manageUserPriv' => @@MLVL_SAFE,
         'wavedb/processPriv' => @@MLVL_SAFE,
#         'wavedb/search' => @@MLVL_SAFE,
         'wavedb/signup' => @@MLVL_SAFE,
         'wavedb/updateUserEmail' => @@MLVL_SAFE,
         'wavedb/welcome' => @@MLVL_SAFE
  }

  protected

  # overwrite this if you want to restrict access to only a few actions
  # or if you want to check if the user has the correct rights  
  # example:
  #
  #  # only allow nonbobs
  #  def authorize?(user)
  #    user.login != "bob"
  #  end
  def authorize?(user)
    controller = (@template && @template.controller && @template.controller.controller_name) || @params['controller'] || 'invalidcon'
    action = @params['action'] || 'invalidact'
    mlkey = "#{controller}/#{action}"
    lvlreq = @@ML[mlkey]
    @mlkey = mlkey
    unless lvlreq
      @message = "Unknown controller/action #{mlkey}"
      return false 
    end
    return true if lvlreq == @@MLVL_SAFE
    return true if lvlreq == @@MLVL_READ && isInList?(user.readp, controller)
    return true if lvlreq == @@MLVL_WRITE && isInList?(user.writep, controller)
    return true if lvlreq == @@MLVL_MANAGE && isInList?(user.managep, controller)
    fail "user.adminp nil; user: #{user.inspect}" unless user.adminp
    return true if lvlreq == @@MLVL_ADMIN && isInList?(user.adminp, controller)
    @message = "Unknown controller/action level #{lvlreq}"
    return false
  end
  
  # overwrite this method if you only want to protect certain actions of the controller
  # example:
  # 
  #  # don't protect the login and the about method
	def protect?(action)
    safeActions = ['index', 'list', 'show', 'show_locnum', 'namesearchsub', 'choseItem']
		if safeActions.include?(action)
			 return false
		else
       writerActions = ['new', 'create', 'edit', 'destroy']
       if writerActions.include?(action)
         if @session['user'] && @session['user'].isWriter?
           return false
         else
					 if @session['user']
						 @session['message'] = "You do not have Writer privileges, please ask a Manager to promote you"
						 redirect_to :controller=>"phonenum", :action =>"list"
					 else
						 @session['message'] = "Must log in."
						 redirect_to :controller=>"wavedb", :action =>"login"
           end
				 end
       end
			 return true
		end
	end
  #def protect?(action)
  #  true
  #end
   
  # login_required filter. add 
  #
  #   before_filter :login_required
  #
  # if the controller should be under any rights management. 
  # for finer access control you can overwrite
  #   
  #   def authorize?(user)
  # 
  def login_required
    
		message = @session['message']

		if message
			@session['message'] = nil
			@message = message
		else
			@message = ''
		end

#    if not protect?(action_name)
#      return true  
#    end
    @user = @session['user'] || User.authenticate('guest','tsunami')
    fail "invalid database : no guest user" unless @user
    # store current location so that we can 
    # come back after the user logged in
    store_location
  
    if authorize?(@user)
      return true
    end
#    puts "#{instance_variables.sort.join(',')}"
    @message = "user #{@user.login} unauthorized for #{@mlkey}"
    # call overwriteable reaction to unauthorized access
    access_denied
    return false
  end

  # overwrite if you want to have special behavior in case the user is not authorized
  # to access the current operation. 
  # the default action is to redirect to the login screen
  # example use :
  # a popup window might just close itself for instance
  def access_denied
    redirect_to :controller=>"wavedb", :action =>"login", :params => {'message' => "***Sorry, you do not have access to this section. Msg:#{@message}"}
  end  
  
  # store current uri in  the session.
  # we can return to this location by calling return_location
  def store_location
   @session['return-to'] = @request.request_uri unless @request.request_uri =~ /\/wavedb\/log/ || @request.request_uri =~ /\/signup$/ || @request.request_uri =~ /manageUserPriv/
  end

  # move to the last store_location call or to the passed default one
  def redirect_back_or_default(default)
    if @session['return-to'].nil?
      redirect_to default
    else
      redirect_to_url @session['return-to']
      @session['return-to'] = nil
    end
  end

  def doHashFunc(str)
    digest = Digest::MD5.hexdigest(str)
    digest.to_s
  end

end
