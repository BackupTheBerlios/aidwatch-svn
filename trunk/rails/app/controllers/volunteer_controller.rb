class VolunteerController < ApplicationController
  layout 'wavedb'
  before_filter :login_required
  include PagedResultsControllerHelper

  def index
    list
    render_action 'list'
  end

  def list
    sorterhelper = nil
    pager = getPager
    volunteers = Volunteer.find_all
    unless pager
      sorterhelper = ApplicationHelper::SortableTableHelper.new(
      Volunteer,
      ApplicationHelper::FlippableSortKey.new("Name"),
      ApplicationHelper::FlippableSortKey.new("Gender", :sex),
      ApplicationHelper::FlippableSortKey.new("Age", :safeAge),
      ApplicationHelper::FlippableSortKey.new("Start", :targetstart),
      ApplicationHelper::FlippableSortKey.new("End", :targetend),
      ApplicationHelper::FlippableSortKey.new("Dest", :targetloc),
      ApplicationHelper::FlippableSortKey.new("Origin", :origcode),
      ApplicationHelper::FlippableSortKey.new("Skill", :skillcat),
      ApplicationHelper::FlippableSortKey.new("Skill Description", :skilldesc)
      )
      pager = PagedResultsPortal.new(volunteers, sorterhelper)
      setPager(pager)
    end
    pagerLoadResults(volunteers)
  end
  def show
    @volunteer = Volunteer.find(alGrabID())
  end

  def new
    @volunteer = Volunteer.new
  end

  def volunteerSearch()
    st = @params['searchterm']
    zt = nil
    acond = [ ]
    ocond = [ ]
    spars = [ ]
    searchfields = ['name', 'skilldesc', 'targetagency', 'notes']
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
    cid = alGrabParams()['cid'] || "0"
    if cid.to_i > 0
      acond << "skillcat = ?"
      spars << cid
    end
    apart = acond.join(' and ')
    results = Volunteer.find_all([apart, spars].flatten, nil)
    if !results || results.size == 0
      @errmsg = "No records found matching #{zt}"
      render 'wavedb/error'
      return
    end
    pagerLoadResults(results)
    render_action 'list'
  end

  def adjustStatusOrLocation
    @volunteer = Volunteer.find(alGrabID())
    @session['vts'] = @volunteer
  end

  def create
    now = Time.now
    @volunteer = Volunteer.new
    @volunteer.attributes = alGrabParams()
    @volunteer.cuid = @user.id
    @volunteer.targetstart = rCreateDate('targetstart')
    @volunteer.targetend = rCreateDate('targetend')
    if @session['choselocfield']
      cmdstr = "@volunteer.#{@session['choselocfield']} = \"#{session['choseloc'].fullcode}\""
      eval cmdstr
      @session['choseloc'] = nil
      @session['choselocfield'] = nil
    end
    if @volunteer.save
      flash['notice'] = 'Volunteer was successfully created.'
      redirect_to :action => 'adjustStatusOrLocation', :id => @volunteer.id
    else
      render_action 'new'
    end
  end

  def showVolunteerFromSession
    @volunteer = @session['vts']
    @session['vts'] = nil
    render_action 'show'
  end

  def edit
    @volunteer = Volunteer.find(alGrabID())
  end

  def update
    @volunteer = Volunteer.find(alGrabID())
    @volunteer.muid = @user.id
    prms = alGrabParams()
    goodParams = prms.dup
    goodParams.delete('action')
    goodParams.delete('controller')
    @volunteer.attributes = goodParams
    @volunteer.targetstart = rCreateDate('targetstart')
    @volunteer.targetend = rCreateDate('targetend')
    logger.info "Here are targetstart: #{@volunteer.targetstart}"
    logger.info "Here are targetend: #{@volunteer.targetend}"
    if @volunteer.save
      flash['notice'] = 'Volunteer was successfully updated.'
      @session['curview'].refreshObj(@volunteer.id) if @session['curview']
      redirect_to :action => 'show', :id => @volunteer.id
    else
      render_action 'edit'
    end
  end

  def destroy
    @deleteMsg = nil
    @volunteer = Volunteer.find(alGrabID())
    if @params['confirmDelete']
      @deleteMsg = "***Click to confirm delete"
      render_action 'show'
    else
    id = @volunteer.id
    @volunteer.destroy
    @params['confirmDelete'] = nil
    @session['curview'].refreshObj(id) if @session['curview']
    redirect_to :action => 'list'
    end
  end

end
