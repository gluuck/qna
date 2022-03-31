class Api::V1::AnswersController < Api::V1::BaseController
  
  def create
    question = Question.find(params[:question_id])
    answer = question.answers.build(answer_params)
    answer.user = current_resource_owner

    if answer.save
      render json: AnswerBlueprint.render_as_json(answer), status: :created
    else
      render json: { succes: false, message:'Cannot create answer', data:  answer.errors.full_messages  }, status: 422
    end
  end

  def update
    answer = Answer.find(params[:id])
    if answer.update(answer_params)
      render json: AnswerBlueprint.render_as_json(answer)
    else
      render json: { succes: false, message:'Cannot update answer', data:  answer.errors.full_messages  }, status: 422
    end
  end

  def destroy
    answer = Answer.find(params[:id])
    if answer.delete
      render json: {status: :ok}
    else
      render json: { succes: false, data:  answer.errors.full_messages  }, status: 404
    end
  end

  private

  def answer_params
    params.require(:answer).permit(:body)
  end
end
