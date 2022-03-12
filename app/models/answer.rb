class Answer < ApplicationRecord
  include Votable
  include Commentable
  
  belongs_to :user
  belongs_to :question

  has_many :links, dependent: :destroy, as: :linkable

  has_many_attached :files

  after_commit on: :create  do
    broadcast_append_to(
      [question,:answers],
      partial: 'answers/answer',
      locals: {answer: self},
      target: 'answer_id'
    )
  end
  
  accepts_nested_attributes_for :links, allow_destroy: true, reject_if: :all_blank

  validates :body, presence: true  
end
