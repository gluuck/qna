require 'rails_helper'

RSpec.describe User, type: :model do
  it { should validate_presence_of :email }
  it { should validate_presence_of :password }
  it { should have_many(:authorizations).dependent(:destroy) }

  let(:author) {create(:user)}

  context 'User is Author' do
    let(:question) { create(:question, user: author) }

    it  'should be author' do
      expect(author).to be_author(question)
    end
  end

  context 'User not Author' do
    let(:question) { create(:question) }
    it  'should not be author' do
      expect(author).to_not be_author(question)
    end
  end

  describe  '.from_omniauth_auth' do
    let!(:user) { create :user }
    let(:auth) { OmniAuth::AuthHash.new(provider: 'github', uid: '123') }

    context 'already has authorization' do
      it 'returns the user' do
        user.authorizations.create(provider: 'github', uid: '123')
        expect(User.from_omniauth(auth)).to eq user
      end
    end

    context 'user has no authorization' do
      context 'user already exists' do
        let(:auth) { OmniAuth::AuthHash.new(provider: 'github', uid: '123', email: user.email) }
        it 'does not create new user' do
          expect { User.from_omniauth(auth) }.to_not change(User, :count)
        end

        it 'creates authorization for user' do
          expect { User.from_omniauth(auth) }.to change(user.authorizations, :count).by(1)
        end

        it 'creates authorization with provider and uid' do
          authorization = User.from_omniauth(auth).authorizations.first

          expect(authorization.provider).to eq auth.provider
          expect(authorization.uid).to eq auth.uid
        end

        it 'returns user' do
          expect(User.from_omniauth(auth)).to eq user
        end
      end

      context 'user does not exist' do
        let(:auth) { OmniAuth::AuthHash.new(provider: 'github', uid: '123', email: 'new@mail.com') }

        it 'creates new user' do
          expect { User.from_omniauth(auth) }.to change(User, :count).by(1)
        end

        it 'returns new user' do
          expect(User.from_omniauth(auth)).to be_a(User)
        end

        it 'fills user email' do
          user = User.from_omniauth(auth)

          expect(user.email).to eq auth.email
        end

        it 'creates authorization for user' do
          user = User.from_omniauth(auth)

          expect(user.authorizations).to_not be_empty
        end

        it 'creates authorization with provider and uid' do
          authorization = User.from_omniauth(auth).authorizations.first

          expect(authorization.provider).to eq auth.provider
          expect(authorization.uid).to eq auth.uid
        end
      end
    end
  end
end
