require 'rails_helper'

feature 'User can edit his question', %q{
  In order to correct mistakes
  As an author of question
  I'd like to be adle to edit my question
} do
  given!(:user) { create(:user) }
  given(:not_author) { create(:user) }
  given!(:question) { create(:question , user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }

  describe 'Unauthenticated user' do
    scenario 'can not edit question to current question page(template show)' do
      visit questions_path(question)
      expect(page).to_not have_link 'Edit'
    end
  end

  describe 'Authenticated user', js: true do
    context 'Author question' do
      background do
        sign_in(user)
        visit questions_path
        lick_on 'Edit'
      end
      scenario 'edit his question' do
        
        fill_in 'Title', with: 'edited title'
        fill_in 'Body',  with: 'edited body'
        click_on 'Ask'

        expect(page).to_not have_content answer.body
        expect(page).to have_content 'edited title'
        expect(page).to have_content 'edited body'
        expect(page).to_not have_selector 'textarea'
      end
      scenario 'edit question with errors' do
        fill_in 'Title', with: ''
        fill_in 'Body', with: ''
        click_on 'Ask'

        expect(page).to have_content question.errors.full_messages.join(' ')
        expect(page).to have_selector 'textarea'
      end
    end

    context 'Not author' do
      scenario 'tries to edit other users question' do
        sign_in(not_author)
        expect(page).to_not have_link 'Edit Question'
      end
    end
  end
end
