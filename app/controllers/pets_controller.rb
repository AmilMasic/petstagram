class PetsController < ApplicationController
  def index
    if user_signed_in?
    @pets = Pet.all
    else
      redirect_to root_path, notice: 'Thou Shalt Nought duuu dat :( Please sing in. '
    end
  end

  def new
    @pet = Pet.new
    @user = current_user
  end

  def create
    @pet = Pet.new(pet_params)
    @user = current_user
    @pet.user = @user
    if @pet.save
      # change the path to display pet once tested it's saving properly
      redirect_to root_path
    else
      render :new
    end
  end

  private

  def pet_params
   params.require(:pet).permit(:id, :name, :age, :breed)
 end
end
