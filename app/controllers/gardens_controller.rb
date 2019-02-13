class GardensController < ApplicationController

  def new
    @garden = Garden.new
    3.times { @garden.plants.build }
  end

  def create
    @garden = current_user.gardens.new(garden_params)
    if @garden.save
      flash[:success] = "Party in My Plants! New Garden Successfully Created!"
      redirect_to garden_path(@garden)
    else
      @errors = @garden.errors
      render :new
    end
  end

  def show
    @garden = Garden.find(params[:id])
  end

  def destroy
    garden = Garden.find(params[:id])
    garden.destroy
    flash[:success] = "Garden successfully deleted."
    redirect_to dashboard_path
  end

  private
  def garden_params
    params.require(:garden)
    .permit(:name, :zip_code, :plants,
      plants_attributes: [:name, :times_per_week])
  end

end
