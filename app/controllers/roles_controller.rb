# frozen_string_literal: true

class RolesController < ApplicationController
  before_action :load_resource, only: [ :edit, :update ]

  def index
    @roles = Role.all.limit( 50 ).includes :patrons_roles
  end

  def edit
    @patrons = @resource.patrons.limit 50
  end

  def update
    @resource.update resource_params
    redirect_to roles_path
  end

  private

  def load_resource
    @resource = Role.find_by name: params[ :name ]
    return nil if @resource.present?

    redirect_to roles_path
  end

  def resource_params
    params.require( :role ).permit( :name )
  end
end
