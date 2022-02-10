class AnswersController < ApplicationController

  def index
  end

  def create
    question = Question.find(params[:question_id])
    answer = question.answers.build(answer_params)
    answer.user = current_user
    if answer.save
      redirect_to question, notice: 'Your answer successfully created.'
    else
      flash[:notice] = answer.errors.full_messages.join(' ')
      render 'questions/show'
    end
  end

  def show
  end

  def edit
  end

  def update
  end

  def destroy
    answer = Answer.find(params[:id])
    if current_user.author?(answer)
      answer.delete
      redirect_to answer.question, notice: 'Your answer successfully deleted'
    else
      redirect_to answer.question, notice: 'You can`t delete answer'
    end
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end
end
