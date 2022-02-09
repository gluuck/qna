require 'rails_helper'

feature 'The user can create an answers to the question ', %q{
  To help the community
  As an authenticated user
  I would like to create an answer to the question
} do
  given(:user) { create(:user) }
  given(:question) { create(:question) }

  describe 'Authenticated user' do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'created an answer to the question' do
      fill_in 'Body', with: 'Answer body'
      click_on 'Add Answer'

      expect(page).to have_content 'Your answer successfully created.'
      expect(page).to have_content 'Answer body'
    end

    scenario 'tried to create an answer to the question with errors' do
      click_on 'Add Answer'

      expect(page).to have_content "Body can't be blank"
    end
  end

  scenario "Unauthenticated user can't create answer" do
    visit question_path(question)

    expect(page).to_not have_link 'Create answer'
  end
end