source 'https://rubygems.org'

# working ruby version
ruby '2.3.0'
# heroku limitation for docker image
# ruby '2.2.3'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
# gem 'rails', '>= 5.0.0.beta2', '< 5.1'
gem 'rails', '~> 5.0.0.beta3'
gem 'actioncable', '5.0.0.beta3'

gem 'sprockets-rails', github: "rails/sprockets-rails"

# Use Puma as the app server
gem 'puma'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
gem 'bootstrap-sass', '~> 3.3', '>= 3.3.6'

# datepicker
gem 'momentjs-rails', '>= 2.9.0' #dependency
gem 'bootstrap3-datetimepicker-rails', '~> 4.17.37'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.1.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks', '~> 5.x'
gem 'jquery-turbolinks'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
# gem 'jbuilder', '~> 2.0'
# Action Cable dependencies for the Redis adapter
gem 'redis', '~> 3.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

gem 'validates_email_format_of'

# user auth
gem 'devise', '4.0.0.rc2'
# send account invitations by email
# gem 'devise_invitable', '~> 1.5.2'
gem 'devise_invitable', :git => 'git://github.com/scambra/devise_invitable.git'

gem 'devise_lastseenable'
# devise extension to measure password strength
# breaks user testing validation
# gem 'devise_zxcvbn'

# user authorization by roles
gem 'cancancan', '~> 1.13', '>= 1.13.1'
gem "rolify"

gem 'delayed_job_active_record'
gem 'daemons'

# search functionality
gem 'twitter-typeahead-rails', :git => "git://github.com/yourabi/twitter-typeahead-rails.git"
# pagination
gem 'will_paginate'

# a way to create ENV variables in both development & production
gem 'figaro'

# use rails variables in javascript with ease
# currently not working for rails 5
# gem 'gon', '~> 6.0', '>= 6.0.1'

# upload files
# gem 'carrierwave', github: 'carrierwaveuploader/carrierwave'
# gem 'mini_magick'
# gem 'rack', github: 'rack/rack'
gem 'rack', '~> 2.0.0.alpha'

# throttle nasty hackers from attempting brute-force attacks or DDOS attacks
gem 'rack-attack'

gem 'sinatra', :github => 'sinatra/sinatra'
# gem "sinatra", github: "sinatra/sinatra", branch: "master"
# gem "sinatra", github: "sinatra/sinatra", branch: "2.2.0-alpha"
gem "refile", github: 'refile/refile', require: "refile/rails"
gem "refile-mini_magick"

# rendering charts
gem 'fusioncharts-rails'

# generating pdf's
gem 'prawn', '~> 2.0', '>= 2.0.2'
gem 'prawn-table'

gem 'pg'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  # gem 'byebug'

  # Use mysql2 as the database for Active Record
	# gem 'mysql2'

	gem 'rspec-rails', '~> 3.5.0.beta4'
	# gem 'rspec-rails', '~> 3.4'

	gem 'factory_girl_rails'

	gem 'brakeman', '~> 3.3', require: false

end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> in views
  # gem 'web-console', '~> 3.0'
  gem 'better_errors'

	gem 'annotate'

	gem 'listen', '~> 3.0.5'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'

# https://github.com/josevalim/rails-footnotes
# 
  # gem 'rails-footnotes', '~> 4.0'
end

group :test do
	gem 'faker', '~> 1.6', '>= 1.6.2'
	gem 'capybara', github: 'jnicklas/capybara'
	gem 'database_cleaner', '~> 1.5', '>= 1.5.1'
	gem 'launchy', '~> 2.4', '>= 2.4.3'
	gem 'selenium-webdriver', '~> 2.52'	
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

group :production do
	gem 'rails_12factor'
	# newrelic monitoring
	gem 'newrelic_rpm'
end