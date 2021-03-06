require 'rails_helper'

RSpec.describe Garden, type: :model do
  describe 'Validations' do
    it { should validate_presence_of(:zip_code) }
    it { should validate_presence_of(:name) }
  end

  describe 'Relationships' do
    it { should have_many(:users) }
    it { should have_many(:plants) }

    it "has owners", :vcr do
      user = create(:user)
      zip = 80218
      garden = create(:garden, name: 'Garden', zip_code: zip, owners: [user])
      expect(garden.owners).to eq([user])
    end
    it 'has caretakers' do
      user = create(:user)
      zip = 80218
      garden = create(:garden, name: 'Garden', zip_code: zip, caretakers: [user])
      expect(garden.caretakers).to eq([user])
    end
  end

  describe 'Instance Methods' do
    describe '#set_lat_long' do
      it 'sets the lat and long for a new garden', :vcr do
        zip = '96814'
        lat = '21.2966976'
        long = '-157.8480364'
        user = create(:user)
        garden = Garden.new(name: 'Garden', zip_code: zip)
        garden.save

        expect(garden.lat).to eq(lat)
        expect(garden.long).to eq(long)
      end
    end
  end
end
