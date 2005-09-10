class PeopleController < ApplicationController
  def index
    list
    render :action => 'list'
  end

  def dbesc(str)
    str = str.clone
    str.gsub!(/\\/,'\\\\\\')
    str.gsub!(/[']/,'\\\\\'')
    "'#{str}'"
  end
  def list
    @person_pages, @people = paginate :person, :per_page => 10
  end

  def search
    searchterm = @params['searchterm']
    if searchterm
      @people = Person.find_by_sql("SELECT * FROM people WHERE MATCH(searchstuff) AGAINST(#{dbesc(searchterm)});");
      @person_pages, @people = paginate :person, :per_page => 10
    else
      @people = nil
    end
  end

  def show
    @person = Person.find(params[:id])
  end

  def new
    @person = Person.new
  end

  def create
    @person = Person.new(params[:person])
    if @person.save
      flash[:notice] = 'Person was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @person = Person.find(params[:id])
  end

  def update
    @person = Person.find(params[:id])
    if @person.update_attributes(params[:person])
      flash[:notice] = 'Person was successfully updated.'
      redirect_to :action => 'show', :id => @person
    else
      render :action => 'edit'
    end
  end

  def destroy
    Person.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
