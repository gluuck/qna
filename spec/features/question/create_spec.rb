require 'rails_helper'

feature 'User can create question', %q{
  In order to get answer from community
  As authenticated user
  I'd like to be able to ask the question
}do
  given(:user) { create(:user) }
  describe 'Authenticated user' do
    background do
      sign_in(user)

      visit questions_path
      click_on 'Ask question'
      visit new_question_path
    end

    scenario 'asks a question', js: true do
      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'text text text'
      click_on 'Ask'

      expect(page).to have_content 'Your question successfully created.'
      expect(page).to have_content 'Test question'
      expect(page).to have_content 'text text text'
    end

    scenario 'asks a question with errors'do
      visit questions_path
      click_on 'Ask question'
      visit new_question_path
      click_on 'Ask'

      expect(page).to have_content "Title can't be blank."
      expect(page).to have_content "Body can't be blank."
    end

    scenario 'asks a question with attached files',js: true do
      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'text text text'

      attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb","#{Rails.root}/spec/spec_helper.rb"]

      click_on 'Ask'

      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end
  end

  context "multiple sessions" do
    scenario 'question appears on another user page' do 
      Capybara.using_session('user') do
        sign_in(user)
        visit questions_path        
      end

      Capybara.using_session('gest') do
        visit questions_path        
      end

      Capybara.using_session('user') do
        click_on 'Ask question'
        fill_in 'Title', with: 'Test question'
        fill_in 'Body', with: 'text text text'
        click_on 'Ask'
        expect(page).to have_content 'Test question'
        expect(page).to have_content 'text text text'       
      end

      Capybara.using_session('gest') do
        expect(page).to have_content 'Test question'       
      end
    end
  end
  
  scenario 'Unauthenticated user tries to asks a question' do
    visit questions_path
    click_on 'Ask question'
    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
