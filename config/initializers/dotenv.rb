# frozen_string_literal: true

Dotenv.require_keys(
  "DATABASE_URL",
  "JWT_RSA_PEM",
  "SECURITY_TOKEN"
)
