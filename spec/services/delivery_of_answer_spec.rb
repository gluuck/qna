require 'rails_helper'

RSpec.describe DeliveryOfAnswer do
  let(:user) { create :user }
  let(:question) { create :question }
  let(:subscription) { create :subscription, user: user, question: question }
  let(:answer) { create :answer, question: question }

  it 'sends notification to follower' do
    expect(FollowNotificationMailer).to receive(:send_answer).with(answer).and_call_original
    subject.send_answer(answer)
  end

  it 'does not send notification to not follower' do
    answer = create :answer

    expect(DeliveryOfAnswerMailer).to_not receive(:send_answer).with(answer).and_call_original
  end
end
