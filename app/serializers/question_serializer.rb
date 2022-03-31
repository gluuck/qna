class QuestionSerializer < ActiveModel::Serializer

  has_many :files

  def files
    object.files.map { |file| Rails.application.routes.url_helpers.rails_blob_path(file, only_path: true) }
  end
end
