
class PhonenumController < ApplicationController
  layout 'wavedb'
  include PagedResultsControllerHelper

  before_filter :login_required

  def index
    list()
    render_action 'list'
  end

  def list
    sorterhelper = nil
    pager = getPager
    phonenums = Phonenum.find_all
    unless pager
     sorterhelper = ApplicationHelper::SortableTableHelper.new(
      Phonenum,
      ApplicationHelper::FlippableSortKey.new("Name"),
      ApplicationHelper::FlippableSortKey.new("Dialcode"),
      ApplicationHelper::FlippableSortKey.new("Notes"),
      ApplicationHelper::FlippableSortKey.new("Category", :cat),
      ApplicationHelper::FlippableSortKey.new("Relevance")
     )
      setPager(PagedResultsPortal.new(phonenums, sorterhelper))
    end
    pagerLoadResults(phonenums)
  end

  def searchCat()
    catID = alGrabID() || 1
    catID = catID.to_i
    pagerLoadResults(Phonenum.find_all(["cat = ?", catID]))
    render_action "list"
  end

  def show
    @phonenum = Phonenum.find(@params['id'])
  end

  def namesearchsub
    st = @params['searchterm']
    havedone = { }
    if st
      zt = "%#{st}%"
      pagerLoadResults(Phonenum.find_all([ "name LIKE ? OR dialcode LIKE ? OR notes LIKE ?",zt,zt,zt]))
    end
    render "phonenum/list"
  end

  def new
    @phonenum = Phonenum.new
  end

  def create
    @phonenum = Phonenum.new(@params['phonenum'])
    @phonenum.uid = @session['user'].id
    if @phonenum.save
      @phonenum.adjustMatch()
      flash['notice'] = 'Phonenum was successfully created.'
      redirect_to :action => 'list'
    else
      render_action 'new'
    end
  end

  def edit
    @phonenum = Phonenum.find(@params['id'])
  end

  def update
    pnum = @params['phonenum']
    unless pnum
      render_action 'list' 
      return
    end
    id = pnum['id']
    unless id
      render_action 'list'
      return
    end
    id = id.to_i
    @phonenum = Phonenum.find(id)
    @phonenum.attributes = pnum
    if @phonenum.save
      @phonenum.adjustMatch()
      flash['notice'] = 'Phonenum was successfully updated.'
      redirect_to :action => 'show', :id => @phonenum.id
    else
      render_action 'edit'
    end
  end

  def destroy
    Phonenum.find(params['id']).destroy
    redirect_to :action => 'list'
  end
end
