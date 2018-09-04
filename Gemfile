source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

gem 'rails', '~> 5.2.1'

gem 'activerecord-jdbcpostgresql-adapter', '~> 50.0', platform: :jruby
gem 'bcrypt', '~> 3.1'
gem 'bootsnap', '~> 1.3.1'
gem 'devise', '~> 4.5'
gem 'dotenv-rails'
gem 'gouge', :github => 'starqle/gouge', require: false
gem 'pg', '~> 1.0', platform: :ruby
gem 'puma', '~> 3.12'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '~> 4.1.18'
gem 'coffee-rails', '~> 4.2'
gem 'turbolinks', '~> 5.1.1'
gem 'jbuilder', '~> 2.7'
gem 'slim'
gem 'bootstrap', '~> 4.1.3'
gem 'jquery-rails'
gem 'kaminari'

group :development, :test do
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'capybara', '~> 3.6'
  gem 'database_cleaner', '~> 1.7'
  gem 'factory_bot_rails', '~> 4.11'
  gem 'faker', '~> 1.9.1'
  gem 'rspec-rails', '~> 3.8'
  gem 'selenium-webdriver'
  gem 'shoulda-matchers', '~> 3.1', '>= 3.1.2'
end

group :development do
  gem 'awesome_print'
  gem 'hirb'
  gem 'listen', '~> 3.1.5'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.1'
  gem 'web-console', '~> 3.6.2'
end

gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
