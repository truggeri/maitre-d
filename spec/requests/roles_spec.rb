# frozen_string_literal: true

require "rails_helper"

describe "roles", type: :request do
  let( :unauthorized_token ) { Token.new( roles: [ "line_cook" ] ).to_s }
  let( :authorized_token ) { Token.new( roles: [ "manage_roles" ] ).to_s }

  before do
    cookies[ "auth_token" ] = authorized_token
  end

  shared_examples_for "an unauthorized request" do
    context "when no token" do
      before do
        cookies[ "auth_token" ] = nil
      end

      it do
        subject
        expect( response ).to have_http_status :unauthorized
      end
    end

    context "when no unauthed token" do
      before do
        cookies[ "auth_token" ] = unauthorized_token
      end

      it do
        subject
        expect( response ).to have_http_status :unauthorized
      end
    end
  end

  describe "index" do
    subject { get roles_path }

    it do
      subject
      expect( response ).to have_http_status :ok
    end

    it_behaves_like "an unauthorized request"
  end

  describe "edit" do
    subject { get edit_role_path( name: given_name ) }

    let( :given_name ) { "fako" }

    it_behaves_like "an unauthorized request"

    context "when name doesn't exist" do
      it do
        subject
        expect( response ).to redirect_to roles_path
      end
    end

    context "when name does exist" do
      let( :given_name ) { role.name }
      let( :role ) { Role.create name: "test-role" }

      it do
        subject
        expect( response ).to have_http_status :ok
      end
    end
  end

  describe "update" do
    subject { patch role_path( name: given_name, params: given_params ) }

    let( :given_params ) do
      {
        role: { name: "new-name" },
      }
    end
    let( :given_name ) { "fako" }

    it_behaves_like "an unauthorized request"

    context "when name doesn't exist" do
      it do
        subject
        expect( response ).to redirect_to roles_path
      end
    end

    context "when name does exist" do
      let( :given_name ) { role.name }
      let( :role ) { Role.create name: "test-role" }

      it "updates the name" do
        subject
        expect( response ).to redirect_to roles_path
        expect( role.reload.name ).to eq "new-name"
      end

      context "when params are bad" do
        let( :given_params ) do
          {
            wrong: { name: "new-name" },
          }
        end

        it "does not update the name" do
          expect { subject }.to raise_error ActionController::ParameterMissing
        end
      end
    end
  end
end
