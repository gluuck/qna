require 'rails_helper'

feature 'The user can choose the best answer to the question', %q{
  To display the best answer to the question above the other answers
  As the author of the question
  I would like to choose the best answer to a question
} do
  given!(:user) { create(:user) }
  given!(:not_author) { create(:user) }

  describe 'Unauthenticated user' do
    scenario 'can not choose the best answer', js: true do
      question = create :question, user: user
      visit questions_path(question)
      expect(page).to_not have_link 'Best answer'
    end
  end

  describe 'Authenticated user', js: true do
    context 'Author of the question' do
      scenario 'can choose the best answer' do
        sign_in(user)
        question = create :question, user: user
        answer = create :answer, question: question, user: not_author
        question.set_best_answer(answer)
        best_answer = question.best_answer
        visit question_path(question)
        within '.answers' do
          expect(page).to have_link 'Best answer'
          click_on 'Best answer'
          expect(page).to have_content best_answer.body
        end
      end
    end

    context 'Not author the question' do
      scenario 'can not choose the best answer' do
        sign_in(not_author)
        question = create :question, user: user
        create :answer, question: question, user: user
        visit question_path(question)
        within '.answers' do
          expect(page).to_not have_link 'Best answer'
        end
      end
    end
  end
end
