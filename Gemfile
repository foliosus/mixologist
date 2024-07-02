source "https://rubygems.org"

ruby File.read(".ruby-version").chomp

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem "rails", "~> 7.1.3", ">= 7.1.3.4"

# The original asset pipeline for Rails [https://github.com/rails/sprockets-rails]
gem "sprockets-rails"

# Use sqlite3 as the database for Active Record
gem "sqlite3", "~> 1.4"

# Use the Puma web server [https://github.com/puma/puma]
gem "puma", ">= 5.0"

# Monkeypatch for File.exists? -> File.exist?
gem "file_exists"

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", require: false

# =========
# Front-end
# =========

gem "importmap-rails"
gem "turbo-rails"
gem "stimulus-rails"
gem "dartsass-rails"
gem "haml-rails"
gem "simple_form"
gem "rails_autolink"

# ==============
# Authentication
# ==============

gem "revise_auth"

# ==============
# Domain support
# ==============

gem 'unicode_utils'
# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[ mswin mswin64 mingw x64_mingw jruby ]


group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "debug", platforms: %i[ mri mswin mswin64 mingw x64_mingw ]
  gem "factory_bot_rails"
end

group :development do
  gem "better_errors"
  gem "binding_of_caller"
end

group :test do
  # Use system testing [https://guides.rubyonrails.org/testing.html#system-testing]
  # gem "capybara"
  # gem "selenium-webdriver"

  gem "minitest-rails"
  gem "minitest-reporters"
  gem "test-unit"
  gem "shoulda"
  gem "database_cleaner-active_record"
  gem "rails-controller-testing"
end
