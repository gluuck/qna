class DeliveryOfAnswer
  attr_reader :answer

  def initialize(answer)
    @answer = answer
  end

  def send_answer
    answer.question.subscriptions.find_each(batch_size: 500) do |subscription|
      unless subscription.user.author?(answer)
        DeliveryOfAnswerMailer.send_new_answer(subscription.user, answer).deliver_later
      end
    end    
  end
end