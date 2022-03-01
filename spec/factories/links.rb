FactoryBot.define do
  factory :link do
    linkable
    name {'Name link'}
    url {'http://test-link-url.com'}

    trait :invalid do
      name { 'Invalid link' }
      url { 'Invalid link' }
    end

    trait :with_gist do
      url { 'https://gist.github.com' }
    end
  end
end
