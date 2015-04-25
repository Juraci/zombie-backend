require 'rails_helper'

describe 'zombies list', type: :request do
  before :example do
    host! 'api.example.com'
  end

  it 'returns list of all zombies' do
    Zombie.create!(name: 'Ash', weapon: 'axe')

    get '/zombies'

    expect(response.status).to eq 200
    expect(response.body).to_not be_empty
  end
end
