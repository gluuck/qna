class AnswersController < ApplicationController
  before_action :set_answer, only: %i[show edit update destroy]

  def index
  end

  def create
    @question = Question.find(params[:question_id])
    @answer = @question.answers.build(answer_params)
    @answer.user = current_user
    if @answer.save
      render turbo_stream: [ turbo_stream.update('answer_id', partial: @question.answers, locals: {answer: Answer.new}),
      turbo_stream.update('notice', 'Your answer successfully created.' ) ]
    else
      render turbo_stream: turbo_stream.update('question_id', partial: 'answers/answer_errors')
    end
  end

  def show
  end

  def edit
    render turbo_stream: turbo_stream.update(@answer, partial: 'answers/form', locals: {answer: @answer})
  end

  def update
    if @answer.update(answer_params)
      render turbo_stream: turbo_stream.update(@answer, partial: 'answers/answer', locals: {answer: @answer})
    end
  end

  def destroy
    if current_user.author?(@answer)
      @answer.delete
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: [turbo_stream.remove(@answer),
                                turbo_stream.update('notice', 'Your answer successfully deleted')]
        end
        format.html{redirect_to @answer.question, notice: 'Your answer successfully deleted'}
      end
    else
      redirect_to @answer.question, notice: 'You can`t delete answer'
    end
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end

  def set_answer
    @answer = Answer.find(params[:id])
  end
end
