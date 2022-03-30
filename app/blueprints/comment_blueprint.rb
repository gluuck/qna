class CommentBlueprint < Blueprinter::Base
  identifier :id
  field :body do |comment|
    comment.body.body
  end
end
