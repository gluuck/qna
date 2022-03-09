FactoryBot.define do
  factory :vote do
    user
    votable
    value { 1 }
    user { nil }
    votable { nil }
  end
end
