require 'rails_helper'
require 'byebug'

describe 'restaurants' do

  feature 'restaurants' do
    context 'no restaurants have been added' do
      scenario 'should display a prompt to add a restaurant' do
        visit '/restaurants'
        expect(page).to have_content 'No restaurants yet'
        expect(page).to have_link 'Add a restaurant'
      end
    end

    context 'restaurants have been added' do
      before do
        Restaurant.create(name: 'KFC')
      end

      scenario 'display restaurants' do
        visit '/restaurants'
        expect(page).to have_content('KFC')
        expect(page).not_to have_content('No restaurants yet')
      end
    end

    context 'creating restaurants' do
      scenario 'prompts user to fill our a form, then displays the new restaurant' do
        visit '/restaurants'
        sign_up(build(:user))
        click_link 'Add a restaurant'
        fill_in 'Name', with: 'KFC'
        click_button 'Create Restaurant'
        expect(page).to have_content 'KFC'
        expect(current_path).to eq '/restaurants'
      end

      scenario 'does not allow adding resturant unless logged in' do
        visit '/restaurants/new'
        expect(page).to have_content("Log in")
      end
    end

    context 'an invalid restaurant' do
      it 'does not let you submit a name that is too short' do
        visit '/restaurants'
        sign_up(build(:user))
        click_link 'Add a restaurant'
        fill_in 'Name', with: 'kf'
        click_button 'Create Restaurant'
        expect(page).not_to have_css 'h2', text: 'kf'
        expect(page).to have_content 'error'
      end
    end

    context 'viewing restaurants' do

      let!(:kfc){Restaurant.create(name:'KFC')}

      scenario 'lets a user view a restaurant' do
       visit '/restaurants'
       click_link 'KFC'
       expect(page).to have_content 'KFC'
       expect(current_path).to eq "/restaurants/#{kfc.id}"
      end
    end

    context 'editing restaurants' do

      scenario 'lets the user who added the restaurant to edit it' do
        restaurant = build(:restaurant)
        sign_up(build(:user))
        add_restaurant(restaurant)
        click_link 'Sign out'
        sign_up(build(:user2))
        click_link "Edit #{restaurant.name}"
        expect(page).to have_content 'You may not edit the restaurant'
        expect(current_path).to eq '/restaurants'
      end
    end

    context 'deleting restaurants' do

      before {Restaurant.create name: 'KFC'}

      scenario 'removes a restaurant when a user clicks a delete link' do
        visit '/restaurants'
        sign_up(build(:user))
        click_link 'Delete KFC'
        expect(page).not_to have_content 'KFC'
        expect(page).to have_content 'Restaurant deleted successfully'
      end
    end

  end
end
