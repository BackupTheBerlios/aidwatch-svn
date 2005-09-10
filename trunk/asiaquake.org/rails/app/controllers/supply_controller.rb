class SupplyController < ApplicationController
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
    supplies = Supply.find_all
    unless pager
      sorterhelper = ApplicationHelper::SortableTableHelper.new(
        Supply,
          ApplicationHelper::FlippableSortKey.new("Name"),
          ApplicationHelper::FlippableSortKey.new("Quantity", :quantity),
          ApplicationHelper::FlippableSortKey.new("Location", :loc),
          ApplicationHelper::FlippableSortKey.new("Status", :status),
          ApplicationHelper::FlippableSortKey.new("Notes", :notes)
          )
      setPager(PagedResultsPortal.new(supplies, sorterhelper))
    end
    pagerLoadResults(supplies)
  end

  def show
    @supply = Supply.find(@params['id'])
  end

  def new
    @supply = Supply.new
  end

  def create
    @supply = Supply.new(@params['supply'])
    if @supply.save
      flash['notice'] = 'Supply was successfully created.'
      redirect_to :action => 'list'
    else
      render_action 'new'
    end
  end

  def edit
    @supply = Supply.find(@params['id'])
  end

  def update
    @supply = Supply.find(@params['supply']['id'])
    @supply.attributes = @params['supply']
    if @supply.save
      flash['notice'] = 'Supply was successfully updated.'
      redirect_to :action => 'show', :id => @supply.id
    else
      render_action 'edit'
    end
  end

  def destroy
    Supply.find(@params['id']).destroy
    redirect_to :action => 'list'
  end
end
