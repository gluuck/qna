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

  describe '.find_for_oauth' do
    let!(:user) { create(:user) }
    let(:auth) { OmniAuth::AuthHash.new(provider: 'github', uid: '123') }
    let(:service) { double('ServiceFindForOauth::FindForOauth') }

    it 'calls ServiceFindForOauth::FindForOauth' do
      expect(ServiceFindForOauth::FindForOauth).to receive(:new).with(auth).and_return(service)
      expect(service).to receive(:call)
      User.from_omniauth(auth)
    end
  end
end
