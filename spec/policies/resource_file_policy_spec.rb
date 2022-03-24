require 'rails_helper'

RSpec.describe ResourceFilePolicy, type: :policy do
  let(:user) { create :user }
  let(:file) { fixture_file_upload("#{Rails.root}/spec/rails_helper.rb", 'text/plain') }
  let(:question) { create :question, user: user, files: [file] }
  let(:answer) { create :answer, user: user, question: question, files: [file] }
  let(:other_user) { create :user }
  let(:other_question) { create :question, user: other_user, files: [file] }
  let(:other_answer) { create :answer, user: other_user, question: other_question, files: [file] }

  subject { described_class }

  permissions :destroy? do
    it 'grants access if user is present and author of file' do
      expect(subject).to permit(user, question.files.first.record)
    end

    it 'denies access if user is not author of file' do
      expect(subject).to_not permit(user, other_question.files.first.record)
    end

    it 'grants access if user is present and author of answer file' do
      expect(subject).to permit(user, answer.files.first.record)
    end

    it 'denies access if user is not author of answer file' do
      expect(subject).to_not permit(user, other_answer.files.first.record)
    end
  end
end