require 'rails_helper'

RSpec.describe LinkPolicy, type: :policy do
  let(:user) { create :user }
  let(:question) { create :question, user: user }
  let(:link) { create :link, linkable: question }

  subject { described_class }

  permissions :destroy? do
    it 'grant access if user presents and author of link' do
      expect(subject).to permit(user, link)
    end
  end
end
