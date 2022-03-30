class AnswerBlueprint < Blueprinter::Base
  identifier :id
  # field :body, if: ->(question, options) { question.best_answer != options[:best_answer] }
  fields :body, :user_id
  association :comments, blueprint: CommentBlueprint
end
