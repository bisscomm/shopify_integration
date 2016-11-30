ruby '2.3.3'
source 'https://rubygems.org'

gem 'sinatra'
gem 'tilt', '~> 1.4.1'
gem 'tilt-jbuilder'
gem 'jbuilder', '2.0.7'
gem 'capistrano'
gem 'rest-client'
gem 'require_all'

group :development, :test do
  gem 'shotgun'
  gem 'pry'
  gem 'pry-byebug'
  gem 'awesome_print'
  gem 'dotenv'
end

group :test do
  gem 'vcr'
  gem 'rspec'
  gem 'webmock'
  gem 'guard-rspec'
  gem 'terminal-notifier-guard'
  gem 'rb-fsevent', '~> 0.9.1'
  gem 'rack-test'
end

group :production do
  gem 'foreman', '0.66.0'
  gem 'unicorn'
end

gem 'endpoint_base', git: 'https://github.com/spree/endpoint_base'

# TODO: Update `endpoint_base` and remove this line below
# after this PR will be merged: https://github.com/spree/endpoint_base/pull/15/files
gem 'activesupport', '~> 4.2.6'