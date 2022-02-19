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
        click_on 'Edit'
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

      scenario 'add files when edited question' do
        visit question_path(question)
        attach_file 'Files', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
        click_on 'Add file'
        # visit question_path(question)

        expect(page).to have_link 'rails_helper.rb'
        expect(page).to have_link 'spec_helper.rb'
      end

      scenario 'edit question with errors' do
        click_on 'Edit'
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
