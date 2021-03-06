require 'rails_helper'

feature 'User can sign up', %q{
  In order to ask questions
  As an unregistered user
  I'd like to be able to sign up
} do

  background do
    visit root_path
    click_link 'Sign up'
  end

  scenario 'User tries to sign up with valid attribute' do
    fill_in 'Email', with: 'first@mail.com'
    fill_in 'Password', with: '123456'
    fill_in 'Password confirmation', with: '123456'
    click_button 'Sign up'

    expect(page).to have_content 'Welcome! You have signed up successfully.'
    expect(page).to have_content 'Exit'
  end

  describe 'User tries to sign up with invalid attribute' do
    given(:user) { create(:user) }

    scenario 'without email and password' do

      click_button 'Sign up'

      expect(page).to have_content "Email can't be blank"
      expect(page).to have_content "Password can't be blank"
    end

    scenario 'invalid email' do
      fill_in 'Email', with: '%dss%.com'
      fill_in 'Password', with: user.password
      fill_in 'Password confirmation', with: user.password_confirmation
      click_button 'Sign up'
      expect(page).to have_content 'Email is invalid'
    end

    scenario 'password is too short' do
      fill_in 'Email', with: 'first@user.com'
      fill_in 'Password', with: '1234'
      fill_in 'Password confirmation', with: '1234'
      click_button 'Sign up'

      expect(page).to have_content 'Password is too short'
    end

    scenario 'passwords do not match' do
      fill_in 'Email', with: 'first@user.com'
      fill_in 'Password', with: '123456'
      fill_in 'Password confirmation', with: '1234567890'
      click_button 'Sign up'

      expect(page).to have_content "Password confirmation doesn't match Password"
    end

    scenario 'email is already exists' do
      fill_in 'Email', with: user.email
      fill_in 'Password', with: user.password
      fill_in 'Password confirmation', with: user.password_confirmation
      click_button 'Sign up'

      expect(page).to have_content 'Email has already been taken'
    end
  end
end