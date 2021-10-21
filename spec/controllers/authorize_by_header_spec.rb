# frozen_string_literal: true

require "rails_helper"

describe "authorize_by_header", type: :controller do
  controller do
    before_action -> { authorize_by_header "manage_roles" }

    def authorize_header
      head :ok
    end
  end

  before do
    routes.draw { get "authorize_header" => "anonymous#authorize_header" }
  end

  subject do
    get :authorize_header
  end

  let( :unauthorized_token ) { Token.new( roles: [ "line_cook" ] ).to_s }
  let( :authorized_token ) { Token.new( roles: [ "manage_roles" ] ).to_s }
  let( :expired_token ) do
    Timecop.freeze( 65.minutes.ago ) do
      Token.new( roles: [ "manage_roles", "old_stuff" ] ).to_s
    end
  end

  before do
    request.headers[ "Authorization" ] = given_header
  end

  context "when header is missing" do
    let( :given_header ) { nil }

    it do
      subject
      expect( response ).to have_http_status :unauthorized
    end
  end

  context "when header is malformed" do
    let( :given_header ) { "a.b.c" }

    it do
      subject
      expect( response ).to have_http_status :unauthorized
    end
  end

  context "when unauthorized" do
    let( :given_header ) { "Bearer #{ unauthorized_token }" }

    it do
      subject
      expect( response ).to have_http_status :unauthorized
    end
  end

  context "when authorized" do
    let( :given_header ) { "Bearer #{ authorized_token }" }

    it do
      subject
      expect( response ).to have_http_status :ok
    end
  end

  context "when token expired" do
    let( :given_header ) { "Bearer #{ expired_token }" }

    it do
      subject
      expect( response ).to have_http_status :unauthorized
    end
  end
end
