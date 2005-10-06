class PetsController < ApplicationController
  def index
    list
    render :action => 'list'
  end

  def list
    @pet_pages, @pets = paginate :pet, :per_page => 10
  end

  def show
    @pet = Pet.find(params[:id])
  end

  def new
    @pet = Pet.new
  end

  def create
    @pet = Pet.new(params[:pet])
    @pet.updateSearchStuff
    if @pet.save
      flash[:notice] = 'Pet was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @pet = Pet.find(params[:id])
  end

  def search
    searchterm = @params['searchterm']
    @searchterm = searchterm
    if searchterm
      numperpage = 50
      paginate_from_sql_pets(Pet, sqlstmtpets(searchterm), Pet.count(whereclause(searchterm)), numperpage)
    else
      @pets = nil
    end
    render :action => 'search'
  end

  def update
    @pet = Pet.find(params[:id])
    if @pet.update_attributes(params[:pet])
      @pet.updateSearchStuff
      @pet.save
      flash[:notice] = 'Pet was successfully updated.'
      redirect_to :action => 'show', :id => @pet
    else
      render :action => 'edit'
    end
  end

  def destroy
    Pet.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
