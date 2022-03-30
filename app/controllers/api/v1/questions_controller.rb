class Api::V1::QuestionsController < Api::V1::BaseController

  def index
    questions = Question.all
    render json: QuestionBlueprint.render_as_json(questions,view: :normal, root: :questions)
  end

  def show
    question = Question.find(params[:id])
    answers = question.answers
    respond_with QuestionBlueprint.render_as_json(question, view: :extended, root: :question)
  end
end
