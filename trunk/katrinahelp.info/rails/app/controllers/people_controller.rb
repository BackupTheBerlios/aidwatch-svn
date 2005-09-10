class PeopleController < ApplicationController
  def index
    search
    render :action => 'search'
  end

  def search
    if isOkToSearch
      searchterm = @params['searchterm']
      if searchterm
        numperpage = 50
        paginate_from_sql(Person, sqlstmt(searchterm), Person.count(whereclause(searchterm)), numperpage)
      else
        @people = nil
      end
      @searchterm = searchterm
    else
      @toobusy = loadavg().to_s
    end
  end

  def show
    @person = Person.find(params[:id])
  end

#  def new
#    @person = Person.new
#  end

#  def create
#    @person = Person.new(params[:person])
#    if @person.save
#      flash[:notice] = 'Person was successfully created.'
#      redirect_to :action => 'list'
#    else
#      render :action => 'new'
#    end
#  end

#  def edit
#    @person = Person.find(params[:id])
#  end

#  def update
#    @person = Person.find(params[:id])
#    if @person.update_attributes(params[:person])
#      flash[:notice] = 'Person was successfully updated.'
#      redirect_to :action => 'show', :id => @person
#    else
#      render :action => 'edit'
#    end
#  end

#  def destroy
#    Person.find(params[:id]).destroy
#    redirect_to :action => 'list'
#  end

end
