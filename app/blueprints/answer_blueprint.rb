class AnswerBlueprint < Blueprinter::Base
  identifier :id

  fields :body, :user_id
  association :comments, blueprint: CommentBlueprint
  association :links, blueprint: LinkBlueprint
  association :files, blueprint: FileBlueprint do |answer|
    answer.files.map { |file| Rails.application.routes.url_helpers.rails_blob_path(file, only_path: true) }
  end
end
