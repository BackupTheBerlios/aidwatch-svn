class PeopleController < ApplicationController
  def index
    search
    render :action => 'search'
  end

  def dbesc(str)
    str = str.clone
    str.gsub!(/\\/,'\\\\\\')
    str.gsub!(/[']/,'\\\\\'')
    "'#{str}'"
  end

  #def list
  #  @person_pages, @people = paginate :person, :per_page => 10
  #end

  def whereclause(searchterm)
      "MATCH(searchstuff) AGAINST(#{dbesc(searchterm)})"
  end

  def sqlstmt(searchterm)
      "SELECT * FROM people WHERE #{whereclause(searchterm)}";
  end

  def search
    searchterm = @params['searchterm']
    if searchterm
      numperpage = 20
      paginate_from_sql(Person, sqlstmt(searchterm), Person.count(whereclause(searchterm)), numperpage)
#      @person_pages, @people = paginate :person, :per_page => 10
    else
      @people = nil
    end
  end

  def paginate_from_sql(model, sql, total, per_page)
    @person_pages = Paginator.new self, total, per_page, @params['page']
    if @person_pages
      @people = model.find_by_sql(sql + " LIMIT #{per_page} " +
                              "OFFSET #{@person_pages.current.to_sql[1]}")
    else
      @people = nil
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
