class AnswersController < ApplicationController

  def index
  end

  def new
    @answer = Answer.new
  end

  def create
    answer = current_user.answers.build(answer_params)
    if answer.save
      redirect_to answer.question, notice: 'Your answer successfully created.'
    else
      flash[:notice] = answer.errors.full_messages.join(' ')
      render :new
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
    answer.delete
    redirect_to answer.question, notice: 'Your answer successfully deleted'
  end

  private

  def answer_params
    params.require(:answer).permit(:body).merge(question_id: params[:question_id])
  end
end
