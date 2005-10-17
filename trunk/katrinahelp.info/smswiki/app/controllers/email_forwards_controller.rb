class EmailForwardsController < ApplicationController
  def index
    list
    render :action => 'list'
  end

  def list
    @email_forward_pages, @email_forwards = paginate :email_forward, :per_page => 10
  end

  def show
    @email_forward = EmailForward.find(params[:id])
  end

  def new
    @email_forward = EmailForward.new
  end

  def create
    @email_forward = EmailForward.new(params[:email_forward])
    if @email_forward.save
      flash[:notice] = 'EmailForward was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @email_forward = EmailForward.find(params[:id])
  end

  def update
    @email_forward = EmailForward.find(params[:id])
    if @email_forward.update_attributes(params[:email_forward])
      flash[:notice] = 'EmailForward was successfully updated.'
      redirect_to :action => 'show', :id => @email_forward
    else
      render :action => 'edit'
    end
  end

  def destroy
    EmailForward.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
