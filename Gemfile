source 'http://rubygems.org'

gem 'rails', '3.0.9'

gem 'rails-i18n'
# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

gem 'pg'
gem 'netzke-core', '0.7.4', :git => "git://github.com/skozlov/netzke-core.git", :tag => 'v0.7.4'
#gem 'netzke-basepack', :path => "/home/vitaly/RubymineProjects/netzke-basepack", :group => [:development, :test]
gem 'netzke-basepack', :git => "git@github.com:wivern/netzke-basepack.git"
gem 'netzke-communitypack'
gem 'acts_as_list', '0.1.4'

# authentication
gem 'devise'
gem 'omniauth', '0.3.2'
gem 'devise_active_directory_authenticatable'
gem 'cancan'
#gem 'devise_active_directory_authenticatable'
# docs reporting
gem 'odf-report'
# import dbf
gem 'dbf'

gem 'russian', '~> 0.6.0'
gem 'seed-fu', '~> 2.0.0'
gem 'deep_cloneable', '~> 1.2.4'
#gem 'delayed_job_active_record'
gem 'rufus-scheduler'

# Use unicorn as the web server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger (ruby-debug for Ruby 1.8.7+, ruby-debug19 for Ruby 1.9.2+)
# gem 'ruby-debug'
# gem 'ruby-debug19', :require => 'ruby-debug'

# Bundle the extra gems:
# gem 'bj'
# gem 'nokogiri'
# gem 'sqlite3-ruby', :require => 'sqlite3'
# gem 'aws-s3', :require => 'aws/s3'

# Bundle gems for the local environment. Make sure to
# put test-only gems in this group so their generators
# and rake tasks are available in development mode:
 group :development, :test do
   gem 'thin'
#   gem 'webrat'
 end

#group :staging do
#  gem 'seedsv'
#end

group :test do
  gem "rspec-rails", "~> 2.6"
  gem 'factory_girl_rails', "~> 4.0"
  gem 'capybara'
  gem 'launchy'
  gem 'database_cleaner'
  gem 'selenium-webdriver'
  gem 'cucumber-rails'
  gem 'faker'
end
