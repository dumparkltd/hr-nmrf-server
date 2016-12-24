# frozen_string_literal: true
class MeasurePolicy < ApplicationPolicy
  def index?
    true
  end

  def new?
    @user.role?('admin') || @user.role?('manager') || @user.role?('reporter')
  end

  def create?
    @user.role?('admin') || @user.role?('manager') || @user.role?('reporter')
  end

  def edit?
    @user.role?('admin') || @user.role?('manager') || @user.role?('reporter')
  end

  def update?
    @user.role?('admin') || @user.role?('manager') || @user.role?('reporter')
  end

  def show?
    @user.present?
  end

  def destroy?
    false
  end

  def permitted_attributes
    [:title, :description, :target_date]
  end

  class Scope < Scope
    def resolve
      scope.all
      # Turn on the code below once we have organisation
      # scope.all if user.role?("admin")
      # scope.where(organisation_id: user.organisation.id)
    end
  end
end
