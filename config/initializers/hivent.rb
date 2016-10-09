file = APP_ROOT.join("config.yml")
config = ::YAML.load(ERB.new(File.read(file)).result)[ENV["APP_ENV"]]

Hivent.configure do |config|
  config.backend         = :redis
  config.endpoint        = ENV["HIVENT_URL"]
  config.partition_count = 4
  config.client_id       = "deployer"
end
