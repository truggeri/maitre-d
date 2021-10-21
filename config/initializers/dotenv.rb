# frozen_string_literal: true

Dotenv.require_keys(
  "DATABASE_URL",
  "JWT_RSA_PEM",
  "JWT_RSA_PUB",
  "SECURITY_TOKEN"
)
