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

  describe 'User adds link when asks answer', js: true do
    sign_in(user)
    visit question_path(question)
    fill_in 'Your answer', with: 'Answer'

    fill_in 'Link name', with: 'My gist'
    fill_in 'Url', with: gist_urls

    click_on 'Add answer'

    with_in '.answers' do
      expect(page).to have_link 'My gist', href: gist_url
    end
  end
end
