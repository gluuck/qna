FactoryBot.define do
  factory :question do
    association (:user)
    title { "MyQuestion" }
    body { "QuestionText" }

    trait :invalid do
      title { nil }
      body { nil }
    end

    trait :with_file do
      file_path = "#{Rails.root}/spec/rails_helper.rb"

      after :create do |answer|
        answer.files.attach(io: File.open(file_path), filename: 'rails_helper.rb')
      end
    end
  end
end
