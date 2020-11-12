source 'https://rubygems.org'

ruby '2.5.1'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails'
gem 'rails-i18n'
# Use postgresql as the database for Active Record
gem 'pg'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
# gem 'jbuilder', '~> 2.0'
# Use Puma as the app server
gem 'puma'

# Use ActiveModel has_secure_password
gem 'bcrypt'

# json formatter
gem 'active_model_serializers'

# Force mail version to prevent security issue
gem 'mail', '2.6.6.rc1'

# Use Capistrano for deployment
group :development do
  gem "capistrano", "~> 3.10", require: false
  gem "capistrano-rails", "~> 1.4", require: false
  gem 'capistrano3-puma'
end
# gem 'capistrano-rails', group: :development

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin AJAX possible
# gem 'rack-cors'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'
end

group :development do
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
end

group :test do
  gem 'rspec-rails'
  gem 'factory_girl_rails'
  gem 'ffaker'
  gem 'codeclimate-test-reporter', require: nil
  gem 'rails-controller-testing'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]