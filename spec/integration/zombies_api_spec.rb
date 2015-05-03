require 'rails_helper'

describe 'zombies api', type: :request do
  before :example do
    host! 'api.example.com'
  end

  context 'when a get request is sent to "/zombies" URI' do
    before :example do
      @schema = {
        type: "object",
        required: ["name", "weapon", "created_at", "updated_at", "id"],
        properties: {
          name: { type: "string" },
          weapon: { type: "string" },
          created_at: { type: "string" },
          updated_at: { type: "string" },
          id: { type: "integer" }
        }
      }
    end

    context 'when the accepted content type is JSON' do
      it 'returns list of all zombies' do
        Zombie.create!(name: 'Ash', weapon: 'axe')

        get '/zombies', { format: 'json' }

        expect(response.status).to eq 200
        expect(response.content_type).to eq Mime::JSON
        expect(JSON::Validator.fully_validate(@schema, response.body, strict: true, list: true)).to be_empty
      end
    end

    context 'when the accepted content type is XML' do
      it 'returns list of all zombies' do
        Zombie.create!(name: 'Ash', weapon: 'axe')

        get '/zombies', { format: 'xml' }

        expect(response.status).to eq 200
        expect(response.content_type).to eq Mime::XML
      end
    end

    it 'returns zombies by id' do
      zombie_ash = Zombie.create!(name: 'Ash', weapon: 'axe')

      get "/zombies/#{zombie_ash.id}"
      expect(response.status).to eq 200
      zombie = json(response.body)
      expect(zombie["name"]).to eq zombie_ash.name
    end

    it 'should be valid against the contract' do
      zombie_ash = Zombie.create!(name: 'Ash', weapon: 'axe')
      get "/zombies/#{zombie_ash.id}"

      expect(JSON::Validator.fully_validate(@schema, response.body, strict: true)).to be_empty
    end

    context 'when querying zombies with a specific weapon' do
      it 'returns only the zombies with that weapon' do
        Zombie.create!(name: 'Ash', weapon: 'axe')
        Zombie.create!(name: 'John', weapon: 'shotgun')

        get '/zombies?weapon=axe', { format: 'json' }

        expect(response.status).to eq 200
        zombies = json(response.body).collect { |z| z["name"] }
        expect(zombies).to include 'Ash'
        expect(zombies).to_not include 'John'
      end
    end
  end

  context 'when a POST request is sent to "/zombies" URI' do
    it 'creates a zombie' do
      post '/zombies', { zombie: { name: 'Ash', weapon: 'axe' } }

      expect(response.status).to eq 201
      expect(response.content_type).to eq Mime::JSON

      zombie = json(response.body)
      expect(response.location).to eq api_zombie_url(zombie['id'])
    end
  end
end
