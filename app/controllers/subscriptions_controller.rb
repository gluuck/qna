class SubscriptionsController < ApplicationController
  before_action :authenticate_user!
  
  def create
    question = Question.find(params[:question_id])
    subscription = question.subscriptions.build(user: current_user) unless current_user.subscribed?(question)
    
    if subscription.present? && subscription.save
      #debugger
      render turbo_stream: [turbo_stream.update('notice', 'You was subscribed  to question'), 
                            turbo_stream.update('subscriptions', partial:'subscriptions/subscribe', locals: { resource: subscription.question, subscription: subscription })]
    else
      render turbo_stream: turbo_stream.update('notice', 'You cant subscribed again')
    end
  end

  def destroy
    subscription = current_user.subscriptions.find(params[:id])
    subscription.delete 
    render turbo_stream: [turbo_stream.update('notice', 'You unsubscribed  from question'),
                          turbo_stream.update('subscriptions', partial:'subscriptions/subscribe', locals: { resource: subscription.question, subscription: subscription })]
  end
end
