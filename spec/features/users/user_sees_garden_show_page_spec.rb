require 'rails_helper'

describe 'as a logged in user' do
  describe 'when they visit the garden show page' do
    it 'shows information about their garden' do
      user = create(:user)
      garden = create(:garden, name: "Back Yard", zip_code: 80206, owners: [user])
      plant_1 = create(:plant, name: "Petunia", times_per_week: 1, garden: garden)
      plant_2 = create(:plant, name: "Sunflower", times_per_week: 3, garden: garden)
      plant_3 = create(:plant, name: "Dahlia", times_per_week: 5, garden: garden)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

      visit garden_path(garden)

      expect(current_path).to eq(garden_path(garden))
      expect(page).to have_content("#{garden.name}")
      expect(page).to have_content("Located in #{garden.zip_code}")

      within ('.plants-container') do
        expect(page).to have_css('.plant', count: 3)
        within("#plant-#{plant_1.id}") do
          expect(page).to have_content(plant_1.name)
          expect(page).to have_content("Watering Requirements: #{plant_1.times_per_week.round(1)} time/week")
        end
        expect(page).to have_content("Watering Requirements: #{plant_2.times_per_week.round(1)} times/week")
      end
      expect(page).to have_link("Add a Plant to Your Garden!")
      expect(page).to have_button("Delete Garden")
      expect(page).to have_link("Update Garden Information")

      within "#schedule-button" do
        click_on "Watering Schedule"
      end
      expect(current_path).to eq(schedules_path)
    end

    it 'only shows information about their garden' do
      user_1 = create(:user)
      garden_1 = create(:garden, name: "My Yard", zip_code: 80206, owners: [user_1])
      plant_1 = create(:plant, name: "Petunia", times_per_week: 5, garden: garden_1)
      user_2 = create(:user)
      garden_2 = create(:garden, name: "Their Yard", zip_code: 80206, owners: [user_2])
      plant_2 = create(:plant, name: "Petunia", times_per_week: 5, garden: garden_2)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user_1)

      visit garden_path(garden_1)

      expect(current_path).to eq(garden_path(garden_1))
      expect(page).to have_content("#{garden_1.name}")
      expect(page).to_not have_content("#{garden_2.name}")
    end

    it 'does not allow them to access another users garden' do
      user_1 = create(:user)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user_1)
      garden_1 = create(:garden, owners: [user_1])

      user_2 = create(:user)
      garden_2 = create(:garden, owners: [user_2])

      visit garden_path(garden_2)

      expect(page.status_code).to eq(404)
      expect(page).to have_content("The page you were looking for doesn't exist.")
    end
  end
end
