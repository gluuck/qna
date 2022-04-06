require 'rails_helper'

RSpec.describe DeliveryOfAnswerJob, type: :job do
  let(:service) { double('DeliveryOfAnswer') }
  let(:answer) { create :answer }

  before do
    allow(DeliveryOfAnswer).to receive(:new).and_return(service)
  end

  it 'calls DeliveryOfAnswer#send_answer' do
    expect(service).to receive(:send_notification).with(answer)
    DeliveryOfAnswerJob.perform_now(answer)
  end
end
