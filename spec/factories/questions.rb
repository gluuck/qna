FactoryBot.define do
  factory :question do
    association(:user)
    title { "MyQuestion" }
    body { "QuestionText" }

    trait :invalid do
      title { nil }
      body { nil }
    end
  end
end
