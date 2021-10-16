# frozen_string_literal: true

source "https://rubygems.org"
git_source( :github ) { |repo| "https://github.com/#{repo}.git" }

ruby "3.0.2"

gem "actionpack", "~> 6.1.4.1"
gem "actionview", "~> 6.1.4.1"
gem "activemodel", "~> 6.1.4.1"
gem "activerecord", "~> 6.1.4.1"
gem "activesupport", "~> 6.1.4.1"
gem "bootsnap", ">= 1.4.4", require: false
gem "jbuilder", "~> 2.7"
gem "pg", "~> 1.1"
gem "puma", "~> 5.0"
gem "railties", "~> 6.1.4.1"
gem "sass-rails", ">= 6"
gem "turbolinks", "~> 5"
gem "webpacker", "~> 5.0"

group :development, :test do
  gem "byebug", platforms: %i[mri mingw x64_mingw]
  gem "rspec-rails", "~> 5.0", ">= 5.0.1"
  gem "rubocop", "~> 1.22", ">= 1.22.1"
  gem "rubocop-rails", "~> 2.12", ">= 2.12.4"
  gem "rubocop-rspec", "~> 2.5"
  gem "simplecov", "~> 0.21.2"
end

group :development do
  gem "listen", "~> 3.3"
  gem "rack-mini-profiler", "~> 2.0"
  gem "spring"
  gem "web-console", ">= 4.1.0"
end

gem "tzinfo-data", platforms: %i[mingw mswin x64_mingw jruby]
