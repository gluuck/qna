class QuestionsController < ApplicationController
  include Voted
  include Commented

  before_action :authenticate_user!, except: %i[index show]
  before_action :set_question, only: %i[show edit update destroy]
  before_action :authorize_question!
  after_action  :verify_authorized


  def index
    @questions = Question.all
  end

  def show
    @answer = Answer.new
    @best_answer = @question.best_answer
    @answer.links.build
    @subscription = Subscription.find_by(user: current_user, question: @question)
  end

  def new
    @question = Question.new
    @question.links.build
    @question.build_reward
  end

  def edit
    render turbo_stream: turbo_stream.update(@question, partial: 'questions/form', locals: {question: @question})
  end

  def create
    @question = current_user.questions.build(question_params)
    if @question.save
      redirect_to @question, notice: 'Your question successfully created.'
    else
      render turbo_stream: turbo_stream.update('question_new', partial: 'questions/question_errors')
    end
  end

  def update
    if @question.update(question_params)
      render turbo_stream: turbo_stream.update(@question, partial: 'questions/question_item', locals: {question: @question})
    else
      render turbo_stream: turbo_stream.update('notice', partial: 'questions/question_errors')
    end    
  end

  def destroy
    respond_to do |format|
      @question.delete
        format.turbo_stream {render turbo_stream: turbo_stream.remove(@question)}
        format.html {redirect_to questions_path, notice: 'Your question successfully deleted'}  
    end    
  end

  private

  def set_question
    @question = Question.includes(:user, :answers, :links).with_attached_files.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body, files: [],
      links_attributes: [:id, :name, :url, :_destroy], reward_attributes: [:name, :image] )
  end

  def authorize_question!
    authorize(@question || Question)
  end
  
end
