source 'https://rubygems.org'

gem 'rake'
gem 'hanami',       '~> 1.2'
gem 'hanami-model', '~> 1.2'

gem 'pg'

gem 'haml'

gem 'capybara'
gem 'selenium-webdriver'
gem 'poltergeist'
gem 'rest-client'
gem 'sidekiq'
gem 'hanami-bootstrap'

group :development do
  # Code reloading
  # See: http://hanamirb.org/guides/projects/code-reloading
  gem 'shotgun', platforms: :ruby
  gem 'hanami-webconsole'
end

group :test, :development do
  gem 'dotenv', '~> 2.0'
  gem 'pry'
end

group :test do
  gem 'rspec'
end

group :production do
  gem 'puma'
end
