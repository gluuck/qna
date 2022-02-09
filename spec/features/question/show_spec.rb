require 'rails_helper'

feature 'User can see question and answers', %q{
  In order to get answer from a community
  as user
  I'd like to be able to views current question and the answers to it
} do
  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given(:answers) { create_list(:answer, 3, question: question ) }

  background { visit question_path(question) }

  scenario 'User can view question' do
    expect(page).to have_content question.title
    expect(page).to have_content question.body
  end

  scenario 'User can view question`s answers' do
    answers.each{ |answer| expect(page).to have_content answer.body}
  end
end
