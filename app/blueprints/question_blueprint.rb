class QuestionBlueprint < Blueprinter::Base
  identifier :id

  view :normal do
    field  :title, name: :title_question do |question|
      question.title.truncate(7)
    end

    fields :body, :user_id
  end

  view :extended do
    field  :title, name: :title_question
    fields :body,  :user_id
    association :best_answer, blueprint: AnswerBlueprint

    association :answers, blueprint: AnswerBlueprint do |question|
      question.answers.where.not(id: question.best_answer)
    end
    association :comments, blueprint: CommentBlueprint
    association :links, blueprint: LinkBlueprint
    association :files, blueprint: FileBlueprint do |question|
      question.files.map { |file| Rails.application.routes.url_helpers.rails_blob_path(file, only_path: true) }
    end
  end
end
