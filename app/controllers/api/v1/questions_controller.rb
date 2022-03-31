class Api::V1::QuestionsController < Api::V1::BaseController
  
  after_action  :verify_authorized

  def index
    authorize Question
    questions = Question.all
    render json: QuestionBlueprint.render_as_json(questions,view: :normal, root: :questions)
  end

  def show
    question = Question.find(params[:id])
    authorize question
    respond_with QuestionBlueprint.render_as_json(question, view: :extended, root: :question)
  end

  def create
    authorize Question
    question = current_resource_owner.questions.build(question_params)
    if question.save
      respond_with QuestionBlueprint.render_as_json(question, view: :extended, root: :question)
    else
      render json: { succes: false, message:'Cannot create question', data:  question.errors.full_messages  }, status: 422
    end
  end

  def update
    question = Question.find(params[:id])
    authorize question
    if question.update(question_params)
      respond_with QuestionBlueprint.render_as_json(question, view: :extended, root: :question)
    else
      render json: { succes: false, message:'Cannot update question', data:  question.errors.full_messages  }, status: 422
    end
  end

  def destroy
    question = Question.find(params[:id])
    authorize question
    if question.delete
      render json: { status: :ok }
    else
      render json: { succes: false, data:  question.errors.full_messages  }, status: 404
    end
  end

  private

  def question_params
    params.require(:question).permit(:title, :body, :user_id)
  end
end
