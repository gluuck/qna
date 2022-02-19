class Answer < ApplicationRecord
  belongs_to :user
  belongs_to :question

  has_many_attached :files

  validates :body, presence: true
  # broadcasts
end
