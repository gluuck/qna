require "rails_helper"

RSpec.describe DeliveryOfAnswerMailer, type: :mailer do
  describe "send_new_answer" do
    let(:user) {create(:user)}
    let(:answer) {create(:amswer)}
    let(:mail) { DeliveryOfAnswerMailer.send_new_answer(user, answer) }

    it "renders the headers" do
      expect(mail.subject).to eq("New Answer")
      expect(mail.to).to eq(["to@example.org"])
      expect(mail.from).to eq(["from@example.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Hi")
    end
  end
end
