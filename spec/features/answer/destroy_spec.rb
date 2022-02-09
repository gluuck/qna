require 'rails_helper'

feature 'User can delete answer', %q{
  In order to remove answer of a question
  As an answer author
  I'd like to be able to delete answer
} do
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, question: question, user: user) }

  scenario 'Author delete his question' do
    sign_in(answer.user)
    visit question_path(answer.question)

    click_on 'Delete Answer'

    expect(page).to have_content 'Your answer successfully deleted'
  end

  scenario 'Not author can not delete question' do
    sign_in(user)
    visit question_path(question)

    expect(page).to_not have_link 'Delete Answer' unless user.author?(question)
  end

  scenario 'Unauthenticated user can not delete question' do
    visit question_path(question)

    expect(page).to_not have_link 'Delete Answer'
  end
end