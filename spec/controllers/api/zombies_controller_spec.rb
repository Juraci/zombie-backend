require 'rails_helper'

describe API::ZombiesController, type: :controller do
  describe 'GET #index' do
    before :example do
      @zombie = Zombie.create!(name: 'Ash', weapon: 'axe')
    end

    it 'responds with 200' do
      get :index
      expect(response.status).to eq 200
    end

    it 'responds with a JSON representation of zombies' do
      get :index
      expect(response.body).to eq([@zombie].to_json)
    end

    context 'when filtering the results by weapon' do
      let!(:params) { { weapon: "axe" } }

      before :example do
        @zombie2 = Zombie.create!(name: 'John', weapon: 'shotgun')
      end

      it 'returns only the zombies with the specified weapon' do
        get :index, params
        expect(response.body).to eq([@zombie].to_json)
      end
    end
  end

  describe 'GET #show' do
    before :example do
      @zombie = Zombie.create!(name: 'Ash', weapon: 'axe')
      @params = { id: @zombie.id }
    end

    it 'returns zombies by id' do
      get :show, @params
      expect(response.status).to eq 200
      expect(response.body).to eq(@zombie.to_json)
    end
  end
end
