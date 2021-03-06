class KennelsController < ApplicationController
  def index
    list
    render :action => 'list'
  end

  def list
    @kennel_pages, @kennels = paginate :kennel, :per_page => 10
  end

  def show
    @kennel = Kennel.find(params[:id])
  end

  def new
    @kennel = Kennel.new
  end

  def create
    @kennel = Kennel.new(params[:kennel])
    if @kennel.save
      flash[:notice] = 'Your Kennel listing has been successfully created.' 
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @kennel = Kennel.find(params[:id])
  end

  def update
    @kennel = Kennel.find(params[:id])
    if @kennel.update_attributes(params[:kennel])
      flash[:notice] = 'Your kennel listing was successfully updated.'
      redirect_to :action => 'show', :id => @kennel
    else
      render :action => 'edit'
    end
  end

  def destroy
    Kennel.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
