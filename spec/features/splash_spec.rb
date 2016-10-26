require 'rails_helper'

RSpec.feature 'Splash', type: :feature do
  it 'app actually loads!' do
    visit '/splash/index'
    expect(page).to have_content('SUCCESS')
  end
end
