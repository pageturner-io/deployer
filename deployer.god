APP_ROOT = File.dirname(__FILE__)

God.watch do |w|
  w.name = "deployer"
  w.dir = APP_ROOT
  w.start = "bin/deployer"

  w.env = {
    "APP_ENV"      => ENV["APP_ENV"],
    "RABBITMQ_URL" => ENV["RABBITMQ_URL"]
  }

  w.keepalive
end
