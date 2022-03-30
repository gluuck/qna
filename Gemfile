source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.0.2"

gem "rails", "~> 7.0.1"

gem "sprockets-rails"

gem "pg", "~> 1.1"

gem "puma", "~> 5.0"

gem "importmap-rails"

gem "turbo-rails"

gem "stimulus-rails"
gem 'aws-sdk-s3', require: false
gem "jbuilder"
gem 'slim-rails'
gem 'devise'
gem "redis", "~> 4.0"
gem 'dotenv-rails'
gem 'jquery-rails'
gem "cocoon"
gem "octokit", "~> 4.0"
gem "tzinfo-data", platforms: %i[ mingw mswin x64_mingw jruby ]
gem 'omniauth'
gem 'omniauth-github', github: 'omniauth/omniauth-github', branch: 'master'
gem 'omniauth-rails_csrf_protection'
gem 'omniauth-vkontakte'
gem "bootsnap", require: false
gem 'cancancan'
gem 'pundit'
gem 'doorkeeper'
gem 'blueprinter'
gem 'oj'

group :development, :test do
  gem "debug", platforms: %i[ mri mingw x64_mingw ]
  gem 'rspec-rails', '~> 5.0.0'
  gem 'factory_bot_rails'
  gem 'letter_opener'
end

group :development do
  gem "web-console"
end

group :test do
  gem "capybara"
  gem "selenium-webdriver"
  gem "webdrivers"
  gem 'shoulda-matchers', '~> 5.0'
  gem 'rails-controller-testing'
  gem 'launchy'
  gem 'capybara-email'
end
