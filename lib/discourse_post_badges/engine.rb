# frozen_string_literal: true

module ::DiscoursePostBadges
  class Engine < ::Rails::Engine
    engine_name PLUGIN_NAME
    isolate_namespace DiscoursePostBadges
    config.autoload_paths << File.join(config.root, "lib")
  end
end
