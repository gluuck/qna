class AnswersController < ApplicationController
  include Voted

  before_action :authenticate_user!, only: %i[create update destroy best_answer]
  before_action :set_answer, only: %i[show edit update destroy best_answer]

  def index
  end

  def new
    @answer = Answer.new
    @answer.links.build
  end

  def create
    @question = Question.find(params[:question_id])
    @answer = @question.answers.build(answer_params)
    @answer.user = current_user
    if @answer.save
      render turbo_stream: [ turbo_stream.update('answer_id', partial: @question.answers, locals: {answer: Answer.new}),
                             turbo_stream.update('notice', 'Your answer successfully created.' ) ]
    else
      render turbo_stream: turbo_stream.update('notice', partial: 'answers/answer_errors')
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
    else
      render turbo_stream: turbo_stream.update('notice', partial: 'answers/answer_errors')
    end
  end

  def destroy
    respond_to do |format|
      if current_user.author?(@answer)
          @answer.delete
            format.turbo_stream do
              render turbo_stream: [turbo_stream.remove(@answer),
                                    turbo_stream.update('notice', 'Your answer successfully deleted')]
            end
            format.html{redirect_to @answer.question, notice: 'Your answer successfully deleted'}
      else
        format.html{redirect_to @answer.question, notice: 'You can`t delete answer'}
      end
    end
  end

  def best_answer
    @question = @answer.question
    if current_user&.author?(@question)
      @question.set_best_answer(@answer)
      render turbo_stream: [turbo_stream.prepend('answer_id', partial: 'answers/answer', locals:{answer: @answer})]
    end
  end

  private

  def answer_params
    params.require(:answer).permit(:body, files: [], links_attributes: [:id, :name, :url, :_destroy] )
  end

  def set_answer
    @answer = Answer.includes(:links).with_attached_files.find(params[:id])
  end
end
