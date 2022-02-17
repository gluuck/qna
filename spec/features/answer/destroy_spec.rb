require 'rails_helper'

feature 'User can delete answer', %q{
  In order to remove answer of a question
  As an answer author
  I'd like to be able to delete answer
} do
  given!(:user) { create(:user) }
  given(:not_author) { create(:user) }
  
  scenario 'Author delete his question', js: true do
    sign_in(user)
    question = create :question, user: user
    answer = create :answer, question: question, user: user

    visit question_path(question)

    expect(page).to have_content(answer.body)

    click_on 'Delete Answer'

    expect(page).to have_content 'Your answer successfully deleted'
    expect(page).to_not have_content(answer)
  end

  scenario 'Not author can not delete question' do
    sign_in(not_author)
    others_question = create :question, user: user
    create :answer, question: others_question, user: user
    visit question_path(others_question)

    expect(page).to_not have_link 'Delete Answer'
  end

  scenario 'Unauthenticated user can not delete question' do
    question = create :question, user: user
    create :answer, question: question, user: user
    visit question_path(question)

    expect(page).to_not have_link 'Delete Answer'
  end
end
