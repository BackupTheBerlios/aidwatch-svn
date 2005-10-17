class WikiMessagesController < ApplicationController
  def index
    list
    render :action => 'list'
  end

  def list
    @wiki_message_pages, @wiki_messages = paginate :wiki_message, :per_page => 10
  end

  def show
    @wiki_message = WikiMessage.find(params[:id])
  end

#  def new
#    @wiki_message = WikiMessage.new
#  end
#
#  def create
#    @wiki_message = WikiMessage.new(params[:wiki_message])
#    if @wiki_message.save
#      flash[:notice] = 'WikiMessage was successfully created.'
#      redirect_to :action => 'list'
#    else
#      render :action => 'new'
#    end
#  end
#
#  def edit
#    @wiki_message = WikiMessage.find(params[:id])
#  end
#
#  def update
#    @wiki_message = WikiMessage.find(params[:id])
#    if @wiki_message.update_attributes(params[:wiki_message])
#      flash[:notice] = 'WikiMessage was successfully updated.'
#      redirect_to :action => 'show', :id => @wiki_message
#    else
#      render :action => 'edit'
#    end
#  end
#
#  def destroy
#    WikiMessage.find(params[:id]).destroy
#    redirect_to :action => 'list'
#  end
end
