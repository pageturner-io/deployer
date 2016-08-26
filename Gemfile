source "https://rubygems.org"

# Prevent invalid byte sequence in US-ASCII (Encoding::InvalidByteSequenceError)
Encoding.default_external = Encoding::UTF_8
Encoding.default_internal = Encoding::UTF_8

# common gems
gem "json"
gem "activesupport"
gem "i18n"
gem "dotenv"

# App specifics
gem "sidekiq"
gem "aws-sdk"
gem "bunny"

group :development, :test do
  gem "guard"
  gem "guard-rspec"
  gem "pry-byebug"
end

group :test do
  gem "rspec"
  gem "rspec-its"
  gem "timecop"
  gem "bunny-mock"

  # code coverage
  gem "simplecov",                 require: false
  gem "codeclimate-test-reporter", require: false
end
