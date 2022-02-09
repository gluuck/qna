require 'rails_helper'

RSpec.describe User, type: :model do
  it { should validate_presence_of :email } 
  it { should validate_presence_of :password } 

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
end
