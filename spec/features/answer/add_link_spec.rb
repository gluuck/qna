require 'rails_helper'

feature 'User can add links to answer', %q{
  In order to provide additional info to my answer
  As an question's author
  I'd like to be abble to add links
} do
  given!(:user) { create(:user) }
  given!(:question) { create(:question) }
  given(:gist_url) { 'https://gist.github.com/gluuck/09e2cfa8f2f9bc69869ff570a9ec1a7b#file-hello-world' }
  given(:google_url) { 'https://google.com/' }
  given(:invalid_url) { 'Invalid_url' }

  describe  'User adds link when asks question', js: true do
    background do
      sign_in(user)
      visit question_path(question)

      fill_in 'Your answer', with: 'Answer'
      click_on 'Add answer'
    end

    scenario 'with valid url', js: true do

      click_on 'Edit'
      click_on 'Add link'

      within '.nested-fields' do
        fill_in 'Link name', with: 'Google'
        fill_in 'Url', with: google_url
      end

      click_on 'Add answer'

      within '.links' do
        expect(page).to have_link 'Google', href: google_url
      end
    end

    scenario 'open gist url', js: true do
      fill_in 'Link name', with: 'My gist'
      fill_in 'Url', with: gist_url

      click_on 'Ask'

      within '.links' do
        expect(page).to have_link 'My gist', href: gist_url
        expect(page).to have_content 'Hello, world!'
      end
    end

    scenario 'with invalid url', js: true do
      fill_in 'Link name', with: 'Invalid'
      fill_in 'Url', with: invalid_url

      click_on 'Ask'

      expect(page).to_not have_link 'Invalid', href: invalid_url
      expect(page).to have_content 'is invalid'
      expect(page).to_not have_content 'Answer'
    end
  end
end
