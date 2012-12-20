source 'https://rubygems.org'

gem 'rails', '3.2.8'
gem 'rake',  '~> 10.0.3'

# Databases
group :development, :test do
  gem 'sqlite3'
end

group :production do
  # Webservers
  gem 'thin'
  gem 'pg'
end

# Rails standard gems
group :assets do
  gem 'sass-rails'
  gem 'bootstrap-sass'
  gem 'coffee-rails'
  gem 'uglifier'
end

# Upload & image processing
gem 'paperclip'

# Nested form
gem "nested_form"

# Haml, sass
gem 'haml-rails'

# Jquery
gem 'jquery-rails'

# Web graphics
gem 'raphael-rails'

# JSON
gem 'json'

# XML parser, builder
gem 'nokogiri'
gem 'builder'

# Authentication
gem 'devise'
gem 'cancan'

# Cronjob
gem "clockwork", "~> 0.4.1"
gem 'delayed_job_active_record'
gem "daemons"

# Add active links to navigation
gem 'active_link_to'

# Testing
gem "capybara"
group :test, :development do
  gem "rspec-rails", "~> 2.0"
end