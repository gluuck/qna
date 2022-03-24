require 'rails_helper'

RSpec.describe CommentPolicy, type: :policy do
  let(:user) { create :user }
  let(:question) { create(:question, user: user) }
  let(:comment) { create(:comment, commentable: question, user: user) }
  let(:answer) { create(:answer , user: user, question: question) }
  let(:comment_answer) { create(:comment, commentable: answer, user: user ) }

  subject { described_class }

  permissions :create_comment? do
    it 'grants access if user presents' do
      expect(subject).to permit(user, comment)
    end

    it 'denies access if user is not present' do
      expect(subject).to_not permit(nil, comment)
    end
    
    it 'grants access answers comment if user presents' do
      expect(subject).to permit(user, comment_answer)
    end

    it 'denies access if answers comment user is not present' do
      expect(subject).to_not permit(nil, comment_answer)
    end
  end  
end
