# frozen_string_literal: true

require_relative "boot"

require "rails"
require "active_model/railtie"
require "active_record/railtie"
require "action_controller/railtie"
require "action_view/railtie"
require "sprockets/railtie"

Bundler.require( *Rails.groups )

module MaitreD
  class Application < Rails::Application
    config.load_defaults 6.1
    # config.eager_load_paths << Rails.root.join("extras")
    config.generators.system_tests = nil
  end
end
