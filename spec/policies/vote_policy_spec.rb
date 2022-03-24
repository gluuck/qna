require 'rails_helper'

RSpec.describe VotePolicy, type: :policy do
  let(:user) { create :user }
  let(:other_user) { create :user }
  let(:votable) { create :question, user: user }
  let(:other_votable) { create :question, user: other_user }

  subject { described_class }

  permissions :vote_up? do
    it 'denies access if user is not present' do
      expect(subject).to_not permit(nil, votable)
    end

    it 'grants access if user is not author of votable' do
      expect(subject).to permit(user, other_votable)
    end

    it 'denies access if user is author of votable' do
      expect(subject).to_not permit(user, votable)
    end
  end

  permissions :destroy_vote? do
    it 'denies access if user is not present' do
      expect(subject).to_not permit(nil, votable)
    end

    it 'grants access if user is not author of votable' do
      expect(subject).to permit(user, other_votable)
    end

    it 'denies access if user is author of votable' do
      expect(subject).to_not permit(user, votable)
    end
  end

  permissions :vote_down? do
    it 'denies access if user is not present' do
      expect(subject).to_not permit(nil, votable)
    end

    it 'grants access if user is not author of votable' do
      expect(subject).to permit(user, other_votable)
    end

    it 'denies access if user is author of votable' do
      expect(subject).to_not permit(user, votable)
    end
  end
end
