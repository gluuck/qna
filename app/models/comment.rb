class Comment < ApplicationRecord
  include ActionView::RecordIdentifier
  ThinkingSphinx::Callbacks.append(self, :behaviours => [:sql])

  belongs_to :user
  belongs_to :commentable, polymorphic: true
  has_rich_text :body

  validates :body, :user, presence: true

  after_create_commit -> {broadcast_append_to [commentable, :comments],
    partial: 'comments/comment',
    target: "#{dom_id(commentable)}_comments"}
end
