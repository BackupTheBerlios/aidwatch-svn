require 'application_helper'
class DiseaseController < ApplicationController

  include ApplicationHelper
  include PagedResultsControllerHelper

  layout 'wavedb'
  before_filter :login_required

  def index
    list
    render_action 'list'
  end

  def list
    sorterhelper = nil
    pager = getPager
    diseases = Disease.find_all
    unless pager
      sorterhelper = ApplicationHelper::SortableTableHelper.new(
        Disease,
  ApplicationHelper::FlippableSortKey.new("Disease", :diseaseName),
  ApplicationHelper::FlippableSortKey.new("Cases", :numcases),
  ApplicationHelper::FlippableSortKey.new("Location", :loc),
  ApplicationHelper::FlippableSortKey.new("Modified", :lastchange),
  ApplicationHelper::FlippableSortKey.new("Notes", :notes)
 )
      setPager(PagedResultsPortal.new(diseases, sorterhelper))
    end
    pagerLoadResults(diseases)
  end

  def diseaseSearch()
    st = @params['searchterm']
    zt = nil
    acond = [ ]
    ocond = [ ]
    spars = [ ]
    searchfields = ['notes']
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
    discat = alGrabParams()['discat'] || "0"
    if discat.to_i > 0
      acond << "discat = ?"
      spars << discat
    end
    apart = acond.join(' and ')
    diseases = Disease.find_all([apart, spars].flatten, nil, 300)
    pagerLoadResults(diseases)
    render_action 'list'
  end

  def show
    @disease = Disease.find(alGrabID())
  end

  def new
    @disease = Disease.new
  end

  def create
    @disease = Disease.new()
    @disease.attributes = alGrabParams()
    @disease.cuid = @user.id
    @disease.lastchange = Time.now
    if @session['choselocfield']
      cmdstr = "@disease.#{@session['choselocfield']} = \"#{session['choseloc'].fullcode}\""
      eval cmdstr
      @session['choseloc'] = nil
      @session['choselocfield'] = nil
    end
    if @disease.save
      flash['notice'] = 'Disease was successfully created.'
      redirect_to :action => 'adjustStatusOrLocation', :id => @disease.id
    else
      render_action 'new'
    end
  end

  def adjustStatusOrLocation
    @disease = Disease.find(alGrabID())
    @session['dts'] = @disease
  end

  def showDiseaseFromSession
    @disease = @session['dts']
    @session['dts'] = nil
    render_action 'show'
  end

  def edit
    @disease = Disease.find(alGrabID())
  end

  def update
    @disease = Disease.find(alGrabID())
    @disease.attributes = alGrabParams()
    @disease.muid = @user.id
    @disease.lastchange = Time.new
    if @disease.save
      flash['notice'] = 'Disease was successfully updated.'
      redirect_to :action => 'show', :id => @disease.id
    else
      render_action 'edit'
    end
  end

  def destroy
    @deleteMsg = nil
    @disease = Disease.find(alGrabID())
    if @params['confirmDelete']
      @deleteMsg = "***Click to confirm delete"
      render_action 'show'
    else
      @disease.destroy
      @params['confirmDelete'] = nil
      redirect_to :action => 'list'
    end
  end

end
