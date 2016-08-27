require_relative "./boot"

Dir[APP_ROOT / "config" / "initializers" / "**" / "*.rb"].each { |f| require f }

require "app/models/source"
require "app/concepts/deployment"
require "app/consumers/build_finishes"
