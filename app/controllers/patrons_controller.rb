# frozen_string_literal: true

class PatronsController < ApplicationController
  before_action -> { authorize_by_cookie "manage_patrons" }
  before_action :load_resource

  def show; end

  def add_role
    @resource.add_role params[ :new_roll ]
    redirect_to patron_path( @resource )
  end

  private

  def load_resource
    param = params[ :name ].presence || params[ :patron_name ]
    @resource = Patron.find_by external_id: param
    return nil if @resource.present?

    redirect_to roles_path
  end
end
