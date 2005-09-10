require 'notifier'
class PersonController < ApplicationController
  layout 'wavedb'
  include PagedResultsControllerHelper

  before_filter :login_required

  def index
    list
    render_action 'list'
  end

  def list
    sorterhelper = nil
    pager = getPager
    people = Person.find_all
    unless pager
      sorterhelper = ApplicationHelper::SortableTableHelper.new(
        Person,
          ApplicationHelper::FlippableSortKey.new("Name"),
          ApplicationHelper::FlippableSortKey.new("Gender", :sex),
          ApplicationHelper::FlippableSortKey.new("Age", :safeAge),
          ApplicationHelper::FlippableSortKey.new("Height", :height),
          ApplicationHelper::FlippableSortKey.new("Hair", :haircolor),
          ApplicationHelper::FlippableSortKey.new("Eyes", :eyecolor),
          ApplicationHelper::FlippableSortKey.new("Status"),
          ApplicationHelper::FlippableSortKey.new("Origin", :origcode),
          ApplicationHelper::FlippableSortKey.new("Last seen", :speclostplace)
         )
      setPager(PagedResultsPortal.new(people, sorterhelper))
    end
    pagerLoadResults(people)
  end

  def show
    @person = Person.find(alGrabID())
  end

  def new
    @person = Person.new
  end

  def create
    @person = Person.new()
    @person.attributes = alGrabParams()
    if @session['choselocfield']
      cmdstr = "@person.#{@session['choselocfield']} = \"#{session['choseloc'].fullcode}\""
      eval cmdstr
      @session['choseloc'] = nil
      @session['choselocfield'] = nil
    end
    if @person.save
      flash['notice'] = 'Person was successfully created.'
      redirect_to :action => 'adjustStatusOrLocation', :id => @person.id
    else
      render_action 'new'
    end
  end

  def personSearch()
    st = @params['searchterm']
    zt = nil
    acond = [ ]
    ocond = [ ]
    spars = [ ]
    searchfields = ['name', 'speclostplace']
    if st
      zt = "%#{st}%"
    else
      zt = "%"
    end
    searchfields.each { |i|
      ocond << "#{i} LIKE ?"
      spars << zt
    }
    opart = ocond.join(' or ')
    acond << "(#{opart})"
    status = alGrabParams()['status'] || nil
    if status.size > 0 && status.to_i >= 0
      acond << "status = ?"
      spars << status
    end
    apart = acond.join(' and ')
    pagerLoadResults(Person.find_all([apart, spars].flatten, nil, 300))
    render_action 'list'
  end

  def adjustStatusOrLocation
    @person = Person.find(alGrabID())
  end

  def edit
    @person = Person.find(alGrabID())
  end

  def addToWatchList
    @person = Person.find(alGrabID())
    if @user.login == 'guest'
      @msg = "guest not allowed to watch"
      return
    end
    emstr = @person.emails
    @person.emails = addToList(emstr, @user.veremail)
    result = @person.save
    @msg = "Added #{@user.veremail} <br> to watchlist for #{@person.name}<br>  which is now #{@person.emails}<br>  with result #{result}<br> "
  end

  def update
    @person = Person.find(alGrabID())
    oldStatus = @person.status.to_i
    @person.attributes = alGrabParams()
    msgs = [ ]
    if @person.save
      newStatus = @person.status.to_i
      unless oldStatus == newStatus
        msgs << "Status changed."
        username = @user.login
        personname = @person.name
        personid = @person.id
        entries(@person.emails).each { |email|
          Notifier.deliver_status_changed_person(email, email, personid, personname)
          msgs << "Sent notify to #{email}"
        }
      end
      flash['notice'] = 'Person was successfully updated.'
      @msg = msgs.join("<br>")
#      redirect_to :action => 'show', :id => @person.id
       render_action 'show'
    else
      msgs << "(no status change)"
      @msg = msgs.join("<br>")
      render_action 'edit'
    end
  end

  def destroy
    @deleteMsg = nil
    @person = Person.find(alGrabID())
    if @params['confirmDelete']
      @deleteMsg = "***Click to confirm delete"
      render_action 'show'
    else
    @person.destroy
    @params['confirmDelete'] = nil
    redirect_to :action => 'list'
    end
  end

end
