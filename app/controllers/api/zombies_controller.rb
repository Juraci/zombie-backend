module API
  class ZombiesController < ApplicationController
    def index
      if weapon = params[:weapon]
        zombies = Zombie.where(weapon: weapon)
      else
        zombies = Zombie.all
      end

      respond_to do |format|
        format.json { render json: zombies, status: 200 }
        format.xml { render xml: zombies, status: 200 }
      end
    end

    def show
      zombie = Zombie.find(params[:id])
      render json: zombie, status: 200
    end

    def create
      zombie = Zombie.new(zombie_params)
      if zombie.save
        render json: zombie, status: 201, location: api_zombie_url(zombie)
      end
    end

    private

    def zombie_params
      params.require(:zombie).permit(:name, :weapon)
    end
  end
end
