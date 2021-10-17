# frozen_string_literal: true

require "rails_helper"

describe "health", type: :request do
  subject { get health_path }

  it do
    subject
    expect( response ).to have_http_status :ok
  end
end
