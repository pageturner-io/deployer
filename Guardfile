# frozen_string_literal: true
guard :rspec, cmd: "RACK_ENV=test bundle exec rspec --color" do
  watch(/^(.+)\.rb$/)           { |m| "spec/#{m[1]}_spec.rb" }
  watch(%r{^app/concepts/(.+)\.rb$})  { |m| "spec/concepts/#{m[1]}_spec.rb" }
  watch(%r{^app/consumers/(.+)\.rb$})  { |m| "spec/consumers/#{m[1]}_spec.rb" }
  watch(%r{^spec/(.+)_spec\.rb$}) { |m| "spec/#{m[1]}_spec.rb" }
  watch('spec/spec_helper.rb')  { "spec/" }
end
