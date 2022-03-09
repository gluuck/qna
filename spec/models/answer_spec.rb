require 'rails_helper'

RSpec.describe Answer, type: :model do
  let!(:answer) {create(:answer)}
  let!(:question) { create(:question) }

  it_behaves_like 'votable_object'

  it { should belong_to(:question) }
  it { should belong_to(:user) }

  it { should have_many(:links).dependent(:destroy) }
  it { should have_many(:votes).dependent(:destroy) }
  it{ should accept_nested_attributes_for :links }

  it { should validate_presence_of(:body) }

  it "have many attached files" do
    expect(answer.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end
end
