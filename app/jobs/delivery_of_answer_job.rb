class DeliveryOfAnswerJob < ApplicationJob
  queue_as :mailers

  def perform(answer)
    DeliveryOfAnswer.new(answer).send_answer
  end
end
