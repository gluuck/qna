require 'rails_helper'

RSpec.describe OauthCallbacksController, type: :controller do
  before { @request.env['devise.mapping'] = Devise.mappings[:user] }

  describe 'Github' do
    let(:oauth_data) { { 'provider' => 'github', 'uid' => 123, 'info' => {} } }

    it 'finds user from oauth data' do
      allow(request.env).to receive(:[]).and_call_original
      allow(request.env).to receive(:[]).with('omniauth.auth').and_return(oauth_data)
      expect(User).to receive(:from_omniauth).with(oauth_data)
      get :github
    end

    context 'user exists' do
      let!(:user) { create(:user) }

      before do
        allow(User).to receive(:from_omniauth).and_return(user)
        get :github
      end

      it 'login user if it exists' do
        expect(subject.current_user).to eq user
      end

      it 'redirects to root path' do
        expect(response).to redirect_to root_path
      end
    end

    context 'user does not exist' do
      before do
        allow(User).to receive(:from_omniauth)
        get :github
      end

      it 'redirects to root path' do
        expect(response).to redirect_to new_user_registration_url
      end

      it 'does not login user' do
        expect(subject.current_user).to_not be
      end
    end
  end

  describe 'Vkontakte' do
    let(:oauth_data) { OmniAuth::AuthHash.new(provider: 'vkontakte', uid: 123) }

    it 'finds user from oauth data' do
      allow(request.env).to receive(:[]).and_call_original
      allow(request.env).to receive(:[]).with('omniauth.auth').and_return(oauth_data)
      expect(User).to receive(:from_omniauth).with(oauth_data)
      get :vkontakte
    end

    context 'user exists' do
      let!(:user) { create :user }

      before do
       allow(User).to receive(:from_omniauth).and_return(user)
       get :vkontakte
      end

      it 'login user' do
       expect(subject.current_user).to eq user
      end

      it 'redirects to root page' do
       expect(response).to redirect_to root_path
      end
    end
  end
end
