# frozen_string_literal: true

require_relative "../../app/lib/bootstrap_user"

BootstrapUser.create! ENV[ "SUPERADMIN_USERNAME" ], ENV[ "SUPERADMIN_PASSWORD" ]
