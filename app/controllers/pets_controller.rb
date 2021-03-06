class PetsController < ApplicationController
  def index
    if user_signed_in?
    @pets = Pet.all.with_attached_images
    else
      redirect_to new_user_registration_path, notice: 'Thou Shalt Nought duuu dat :( Please sing in. '
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
      @pet.images.attach(params[:pet][:images])
      # change the path to display pet once tested it's saving properly
      redirect_to root_path
    else
      render :new
    end
  end

  def show
    @pet = Pet.find_by(id: params[:id])
    if !@pet
      flash[:message] = "Pet was not found."
      redirect_to pets_path
    end
  end

  def edit
    @pet = Pet.find_by(id: params[:id])
  end

  def update
    @pet = Pet.find(params[:id])
    if params[:pet][:image_ids]
      params[:pet][:image_ids].each do |image_id|
        image = @pet.images.find(image_id)
        image.purge
      end
    end
    if @pet.update_attributes(pet_params)
      @pet.images.attach(params[:pet][:images])
      flash[:success] = "Edited"
      redirect_to pets_url
    else
      render :edit
    end
  end

  def destroy
   @pet = Pet.find_by(id: params[:id])
   # if current_user == @pet.owner
     @pet.destroy
     redirect_to pets_path, notice: 'Deleted'
   # else
   #   redirect_to pets_path, notice: 'You are not authorized to delete this pet.'
   # end
 end

  private

  def pet_params
   params.require(:pet).permit(:id, :name, :age, :breed)
 end
end
