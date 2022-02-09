require 'rails_helper'

feature 'User can logout', %q{
  For account security
  As an authenticated user
  I would like to be able logout
} do
  given(:user) { create(:user) }

  scenario 'Registered user tries to logout' do
    sign_in(user)
    click_on 'Exit'
    expect(page).to have_content 'Signed out successfully.'
  end

  scenario 'Unregistered user tries to logout' do
    visit root_path
    expect(page).to_not have_content 'Exit'
  end
end