# frozen_string_literal: true

require "rails_helper"

describe "roles", type: :request do
  describe "index" do
    subject { get roles_path }

    it do
      subject
      expect( response ).to have_http_status :ok
    end
  end

  describe "edit" do
    subject { get edit_role_path( name: given_name ) }

    context "when name doesn't exist" do
      let( :given_name ) { "fako" }

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

    context "when name doesn't exist" do
      let( :given_name ) { "fako" }

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
