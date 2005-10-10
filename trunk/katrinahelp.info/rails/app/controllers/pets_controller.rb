class PetsController < ApplicationController
  private
  def prompt_invalid_record(prompt="You have requested an invalid record.")
      flash[:notice] = prompt
      redirect_to :action => 'list'
  end

  public
  def index
    list
    render :action => 'list'
  end

  def list
    @pet_pages, @pets = paginate :pet, :per_page => 10
  end

  def changekennel
    @pet = Pet.find(params[:id])
    @kennels = Kennel.find_all
    rescue
      prompt_invalid_record
  end

  def updatekennelto
    @pet = Pet.find(params[:id])
    @kennel = Kennel.find(params[:kenid])
    if @pet && @kennel
      @pet.kennel = @kennel
      @pet.save
    end
    render :action => 'show'
    rescue
      prompt_invalid_record
  end

  def show
    @pet = Pet.find(params[:id])
    if @pet
      @kennel = @pet.kennel
    end
    rescue
      prompt_invalid_record("Sorry, we can't find the pet you requested.")
  end


  def new
    @pet = Pet.new_with_defaults
  end

  def create
    @pet = Pet.new(params[:pet])
    @pet.updateSearchStuff
    if @pet.save
      flash[:notice] = 'Your pet listing was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @pet = Pet.find(params[:id])
    # prevents throwing an exception in the case of an invalid pet id
    rescue
      prompt_invalid_record
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
      flash[:notice] = 'Your pet listing was successfully updated.'
      redirect_to :action => 'show', :id => @pet
    else
      render :action => 'edit'
    end
    rescue
      prompt_invalid_record
  end

  def destroy
    Pet.find(params[:id]).destroy
    redirect_to :action => 'list'
    rescue
      prompt_invalid_record
  end
end
