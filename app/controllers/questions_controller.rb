class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  before_action :set_question, only: %i[show edit update destroy]
  def index
    @questions = Question.all
  end
  
  def show
    @answer = Answer.new
  end

  def new 
    @question = current_user.questions.build   
  end
  
  def edit
  end

  def create
    @question = current_user.questions.build(question_params)
    if @question.save
      redirect_to @question, notice: 'Your question successfully created.'
    else
      render :new
    end
  end
  
  def update
    if current_user.author?(@question)

      @question.update(question_params)
      redirect_to @question
    else
      render :edit, notice: 'You can`t update question'
    end
  end
  
  def destroy
    if current_user.author?(@question)
      
      @question.delete
      redirect_to questions_path, notice: 'Your question successfully deleted'
    else
      redirect_to @question, notice: 'Cannot be deleted. You are not the author of the question.'
    end
  end

  private
  
  def set_question
    @question = Question.find(params[:id]) 
  end

  def question_params
    params.require(:question).permit(:title, :body)
  end 
end
