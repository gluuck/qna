FactoryBot.define do
  factory :reward do
    question
    name { 'MyReward' }
    after :create do |reward|
      file_path = "#{Rails.root}/app/assets/images/Badge.png"
      reward.image.attach(io: File.open(file_path), filename: 'Badge.png')
    end
  end
end
