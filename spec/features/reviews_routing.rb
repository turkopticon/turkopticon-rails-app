require 'rails_helper'

RSpec.feature 'Reviews routing', type: :feature do
  describe 'default behavior' do
    it 'loads the default index which is "Recent Reviews"' do
      visit '/reviews'
      expect(page).to have_content('Recent Reviews')
    end

    it 'can be reached from the header link' do
      visit '/'
      click_link 'Recent'
      expect(page).to have_content('Recent Reviews')
    end
  end

  describe 'Query string parsing' do
    # before(:each) do
    # end

    it 'isolates a single user' do
      visit '/reviews?user=90983'
      expect(page).to have_content('by 90983')
    end

    it 'isolates a single requester' do
      visit '/reviews?rid=A9WML20MMM'
      expect(page).to have_content('for A9WML20MMM')
    end
    it 'isolates comments from a single user' do
      visit '/reviews?user=238&comments=true'
      expect(page).to have_content('with comments by 238')
    end
    it 'isolates all reviews with both comments and flags' do
      visit '/reviews?flags=true&comments=true'
      expect(page).to_not have_content('by')
    end
  end
end