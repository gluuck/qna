require 'rails_helper'

feature 'User can subscribe on the on the new answer to question', %q{
    In order to notify email
    As an authenticated user
    I would like to be notified of a new answer to a question
} do
  given!(:author) { create(:user) }
  given(:not_author) { create(:user) }
  given!(:question) { create(:question, user: author) }
  given(:subscription) { create(:subscription, question: question, user: author) }

  describe 'Authenticated user' do
    context 'auhtor of question' do
      background do
        sign_in(author)
        visit question_path(question)
      end

      scenario 'have subscription by default' do
        within('#subscription') do
          expect(page).to have_link 'Unsubscribed'
        end
      end

      scenario 'can unsubscribe', js: true do
        within('#subscription') do
          expect(page).to_not have_link 'Subscribe'
          expect(page).to have_link 'Unsubscribed'

          click_link 'Unsubscribed'

          expect(page).to_not have_link 'Unsubscribed'
          expect(page).to have_link 'Subscribe'
        end
      end
    end

    context 'not author of question', js: true do
      scenario 'can subscribe' do
        sign_in(not_author)
        visit question_path(question)

        within('#subscription') do
          expect(page).to_not have_content 'Unsubscribed'
          expect(page).to have_content 'Subscribe'

          click_link 'Subscribe'

          expect(page).to have_content 'Unsubscribed'
          expect(page).to_not have_content 'Subscribe'
        end
      end

      scenario 'can unsubscribe' do
        sign_in(not_author)
        visit question_path(question)
        click_link 'Subscribe'

        within('#subscription') do
          expect(page).to have_content 'Unsubscribed'
          expect(page).to_not have_content 'Subscribe'

          click_link 'Unsubscribed'

          expect(page).to_not have_content 'Unsubscribed'
          expect(page).to have_content 'Subscribe'
        end
      end
    end
  end

  describe 'Not authenticate user', js: true do
    scenario 'can not see link subscribe or unsubscribe' do
      visit question_path(question)
      expect(page).to_not have_content 'Unsubscribed'
      expect(page).to_not have_content 'Subscribe'
    end
  end
end
