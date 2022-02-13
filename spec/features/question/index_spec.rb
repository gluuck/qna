require 'rails_helper'

feature 'User can see all questions', %q{
  In order to find question
  I'd like to be able see all questions
}do
  given!(:questions) { create_list(:question,5) }
  scenario 'Show all questions titles' do
    visit questions_path

    expect(page).to have_content 'All Questions'
    questions.pluck(:title).each { |title| expect(page).to have_content title }
  end 
end