class Question < ApplicationRecord
  has_many :answers, class_name: "answer", foreign_key: "reference_id"
  
  validates :title, :body, presence: true
end
