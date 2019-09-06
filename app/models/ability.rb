# frozen_string_literal: true
class Ability
  include CanCan::Ability

  def initialize(user)
    # user ||= User.new
    can :index, User 
    if user.present?
      can :manage, User
    end
  end
end
