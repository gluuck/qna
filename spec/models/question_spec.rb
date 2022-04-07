require 'rails_helper'

RSpec.describe Question, type: :model do
  let!(:question) {create(:question)}

  #it_behaves_like 'votable_object'

  it { should have_many(:answers).dependent(:destroy) }
  it { should have_many(:links).dependent(:destroy) }
  it { should have_many(:votes).dependent(:destroy) }
  it { should have_many(:subscriptions).dependent(:destroy) }
  it { should belong_to(:user) }

  it{ should accept_nested_attributes_for :links }

  it { should validate_presence_of(:title) }
  it { should validate_presence_of(:body) }
  it "have many attached files" do
    expect(question.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end

  describe 'reputation' do
    let(:question) { build(:question)}

    it 'calls ReputationJob' do
      expect(ReputationJob).to receive(:perform_later).with(question)
      question.save!
    end
  end
end
