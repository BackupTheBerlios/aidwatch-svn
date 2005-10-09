class WatchesController < ApplicationController
  def index
    list
    render :action => 'list'
  end

  def list
    @watch_pages, @watches = paginate :watch, :per_page => 10
  end

  def show
    @watch = Watch.find(params[:id])
  end

  def new
    @watch = Watch.new
  end

  def create
    @watch = Watch.new(params[:watch])
    if @watch.save
      flash[:notice] = 'Watch was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @watch = Watch.find(params[:id])
  end

  def update
    @watch = Watch.find(params[:id])
    if @watch.update_attributes(params[:watch])
      flash[:notice] = 'Watch was successfully updated.'
      redirect_to :action => 'show', :id => @watch
    else
      render :action => 'edit'
    end
  end

  def destroy
    Watch.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
