source 'https://rubygems.org'
ruby '2.0.0'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.0.0.beta1'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 4.0.0.beta1'
  gem 'coffee-rails', '~> 4.0.0.beta1'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  # gem 'therubyracer', platforms: :ruby
  
  gem 'uglifier', '>= 1.0.3'

end

gem "bourbon", "~> 3.1.6"
gem 'zurb-foundation'

group :test do
  gem 'cucumber-rails', :require => false
  gem 'database_cleaner'
  gem 'database_cleaner'
  gem 'capybara'
  gem 'factory_girl_rails'

end

group :test, :development do
  gem "rspec-rails", "~> 2.0"
  gem 'pg'
  gem 'debugger'
  gem 'faker'
end

group :development do
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'meta_request'
  # gem 'sqlite3'
end

group :production do
  gem 'pg'
end

gem 'jquery-rails'

gem 'roxml'

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 1.0.1'

# To use ActiveModel has_secure_password
gem 'bcrypt-ruby', '~> 3.0.0'

 # Authentication
gem 'devise', :git => 'https://github.com/plataformatec/devise.git', :branch => 'rails4'

# Authorization
gem 'cancan'
gem 'rolify', :git => 'https://github.com/EppO/rolify.git'

# Configuration helper
gem 'figaro'

gem 'thin' # app server

# Deploy with Capistrano
# gem 'capistrano', group: :development

# To use debugger
# gem 'debugger'

# helpers
gem 'active_link_to' # https://github.com/twg/active_link_to
gem 'formtastic', :git => 'https://github.com/justinm715/formtastic.git'
gem 'stringex'