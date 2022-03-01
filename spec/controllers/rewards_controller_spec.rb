require 'rails_helper'

RSpec.describe RewardsController, type: :controller do
  let(:user) { create :user }
  let(:question) {create :question}
  let(:reward) { create :reward, question: question }

  describe 'GET #index' do
    context 'authenticated user' do
      before do
        log_in(user)

        get :index
      end

      it 'populates an array of all awards' do
        expect(assigns(:rewards)).to match_array(user.rewards)
      end

      it 'renders index view' do
        expect(response).to render_template :index
      end
    end

    context 'unauthenticated user' do
      before { get :index }

      it 'redirects to login view' do
        expect(response).to redirect_to new_user_session_path
      end
    end
  end
end
