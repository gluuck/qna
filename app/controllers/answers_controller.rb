class AnswersController < ApplicationController

  def index
  end

  def new
  end

  def create
    question = Question.find(params[:question_id])
    @answer = question.answers.new(answer_params)
    if @answer.save
      redirect_to question_answers_path
    else
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
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end

end
