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

    context 'when a query to filter zombies with a specific weapon is is sent' do
      it 'returns only the zombies with that weapon' do
        Zombie.create!(name: 'Ash', weapon: 'axe')
        Zombie.create!(name: 'John', weapon: 'shotgun')

        get '/zombies?weapon=axe'

        expect(response.status).to eq 200
        zombies = JSON.parse(response.body).collect { |z| z["name"] }
        expect(zombies).to include 'Ash'
        expect(zombies).to_not include 'John'
      end
    end
  end
end
