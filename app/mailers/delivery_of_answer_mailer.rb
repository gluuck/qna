class DeliveryOfAnswerMailer < ApplicationMailer

  def send_new_answer(user, answer)

    @question = answer.question    
    mail to: user.email
  end
end
