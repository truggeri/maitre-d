# frozen_string_literal: true

require "rails_helper"

describe BootstrapUser do
  describe "create!" do
    subject { described_class.create! given_username, given_password }

    let( :given_username ) { "some-user" }
    let( :given_password ) { "some-password" }

    context "when username blank" do
      let( :given_username ) { "" }

      it do
        expect { subject }.not_to change( Patron, :count )
        expect( subject ).to eq nil
      end
    end

    context "when password blank" do
      let( :given_password ) { "" }

      it do
        expect { subject }.not_to change( Patron, :count )
        expect( subject ).to eq nil
      end
    end

    context "when the special user doesn't yet exist" do
      it do
        expect { subject }.to change( Patron, :count ).by 1
        patron = Patron.last
        expect( patron.external_id ).to eq "maitre-d-superadmin"
        expect( patron.auth_type ).to eq "email"
        expect( patron.email_auth.authenticate( given_password ) ).not_to eq false
        expect( patron.has_role?( "manage_roles" ) ).to eq true
      end
    end

    context "when the special user already exists" do
      before do
        Patron.create! auth_type: "email", external_id: "maitre-d-superadmin"
      end

      it do
        expect { subject }.not_to change( Patron, :count )
        patron = Patron.find_by external_id: "maitre-d-superadmin"
        expect( patron.auth_type ).to eq "email"
        expect( patron.email_auth.authenticate( given_password ) ).not_to eq false
        expect( patron.has_role?( "manage_roles" ) ).to eq true
      end
    end
  end
end
