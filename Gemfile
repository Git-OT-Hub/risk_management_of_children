source "https://rubygems.org"

ruby "3.2.2"

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem "rails", "7.1.2"

# The original asset pipeline for Rails [https://github.com/rails/sprockets-rails]
gem "sprockets-rails", "3.4.2"

# Use sqlite3 as the database for Active Record

# Use the Puma web server [https://github.com/puma/puma]
gem "puma", "6.4.0"

# Bundle and transpile JavaScript [https://github.com/rails/jsbundling-rails]
gem "jsbundling-rails", "1.2.1"

# Hotwire's SPA-like page accelerator [https://turbo.hotwired.dev]
gem "turbo-rails", "1.5.0"

# Hotwire's modest JavaScript framework [https://stimulus.hotwired.dev]
gem "stimulus-rails", "1.3.0"

# Bundle and process CSS [https://github.com/rails/cssbundling-rails]
gem "cssbundling-rails", "1.3.3"

# Build JSON APIs with ease [https://github.com/rails/jbuilder]
gem "jbuilder", "2.11.5"

# Use Redis adapter to run Action Cable in production
gem "redis", "5.0.8"

# Use Kredis to get higher-level data types in Redis [https://github.com/rails/kredis]
# gem "kredis"

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
# gem "bcrypt", "~> 3.1.7"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[ windows jruby ]

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", "1.17.0", require: false

# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
gem "image_processing", "1.12.2"

gem "aws-sdk-s3", "1.142.0", require: false
gem "aws-sdk", "3.2.0"

gem "config", "5.0.0"

gem "kaminari", "1.2.2"
gem "bootstrap5-kaminari-views", "0.0.1"

gem "pry-byebug", "3.10.1"

gem "rails-i18n", "7.0.8"

gem "ransack", "4.1.1"

gem "redis-rails", "5.0.2"

gem "sorcery", "0.16.5"

gem "enum_help", "0.0.19"

gem "meta-tags", "2.20.0"

gem "sidekiq", "7.2.2"

gem "sitemap_generator", "6.3.0"

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "debug", "1.8.0", platforms: %i[ mri windows ]
  gem "sqlite3", "1.6.9"
  gem "rspec-rails", "6.1.0"
  gem "factory_bot_rails", "6.4.2"
  gem "faker", "3.2.2"
  gem "letter_opener_web", "2.0.0"
end

group :development do
  # Use console on exceptions pages [https://github.com/rails/web-console]
  gem "web-console", "4.2.1"

  # Add speed badges [https://github.com/MiniProfiler/rack-mini-profiler]
  # gem "rack-mini-profiler"

  # Speed up commands on slow machines / big apps [https://github.com/rails/spring]
  # gem "spring"
end

group :test do
  # Use system testing [https://guides.rubyonrails.org/testing.html#system-testing]
  gem "capybara", "3.39.2"
  gem "selenium-webdriver", "4.15.0"
end

group :production do
  gem "pg", "1.5.4"
end
