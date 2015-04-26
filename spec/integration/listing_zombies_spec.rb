require 'rails_helper'

describe 'zombies api', type: :request do
  before :example do
    host! 'api.example.com'
  end

  context 'when a get request is sent to "/zombies" URI' do
    it 'returns list of all zombies' do
      Zombie.create!(name: 'Ash', weapon: 'axe')

      get '/zombies'

      expect(response.status).to eq 200
      expect(response.body).to_not be_empty
    end

    it 'returns zombies by id' do
      zombie_ash = Zombie.create!(name: 'Ash', weapon: 'axe')

      get "/zombies/#{zombie_ash.id}"
      expect(response.status).to eq 200
      zombie = json(response.body)
      expect(zombie["name"]).to eq zombie_ash.name
    end

    context 'when querying zombies with a specific weapon' do
      it 'returns only the zombies with that weapon' do
        Zombie.create!(name: 'Ash', weapon: 'axe')
        Zombie.create!(name: 'John', weapon: 'shotgun')

        get '/zombies?weapon=axe'

        expect(response.status).to eq 200
        zombies = json(response.body).collect { |z| z["name"] }
        expect(zombies).to include 'Ash'
        expect(zombies).to_not include 'John'
      end
    end
  end
end
