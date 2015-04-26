module API
  class ZombiesController < ApplicationController
    def index
      if weapon = params[:weapon]
        zombies = Zombie.where(weapon: weapon)
      else
        zombies = Zombie.all
      end

      render json: zombies, status: 200
    end

    def show
      zombie = Zombie.find(params[:id])
      render json: zombie, status: 200
    end
  end
end
