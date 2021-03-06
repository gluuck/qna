require 'rails_helper'
feature 'User can edit his answer', %q{
  In order to correct mistakes
  As an author of answer
  i'd like to be able to edit my answer
} do
  given!(:user) {create(:user)}
  given(:not_author) { create(:user) }
  given!(:question) {create(:question, user: user)}
  given!(:answer) {create(:answer, question: question, user: user)}

  scenario 'Unathenticated can not edit answer'do

    visit question_path(question)
    expect(page).to_not have_link 'Edit'
  end

  describe 'Authenticated user', js: true do

    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'edit his answer' do

      visit question_path(question)
      within '.answers' do
        click_on 'Edit'

        fill_in 'Body', with: 'edited body'

        click_on 'Add Answer'

        expect(page).to_not have_content answer.body
        expect(page).to have_content 'edited body'
        expect(page).to_not have_selector 'textarea'
      end
    end

    scenario 'edit his answer with errors' do

      visit question_path(question)
      within '.answers' do
        
        fill_in 'Body', with: ''

        click_on 'Add Answer'

        expect(page).to have_content (answer.body)
        expect(page).to have_selector 'textarea'
     end

      within '.answers' do
        click_on 'Edit'
        expect(page).to have_content answer.errors.full_messages.join(' ')
      end
    end
  end

  context 'Not author answer' do
      scenario 'tries to edit other users answer' do
        sign_in(not_author)
        expect(page).to_not have_link 'Edit answer'
      end
    end
end
