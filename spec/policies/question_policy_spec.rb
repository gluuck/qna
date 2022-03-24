require 'rails_helper'

RSpec.describe QuestionPolicy, type: :policy do
  let(:user) { create(:user) }

  subject { described_class }

  permissions :index?, :show? do
    it 'grants access for all users' do
      expect(subject).to permit(nil, create(:question))
    end
  end

  permissions :new?, :create? do
    it 'grants access if user present' do
      expect(subject).to permit(user, create(:question))
    end
  end

  permissions :update?, :destroy? do
    it 'if user is an admin can update question' do
      expect(subject).to permit(User.new(admin: true)), create(:question)
    end

    it "grant access if user author" do
      expect(subject).to permit( user, create( :question, user: user ) )
    end

    it 'denies access if user not author' do
      expect(subject).to_not permit(User.new, create(:question, user: user))
    end
  end
end
