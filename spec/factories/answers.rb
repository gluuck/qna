FactoryBot.define do
  factory :answer do
    association (:question)
    association (:user)
    body { "MyString" }

    trait :invalid do
      body { nil }
    end
  end
end
