class ActivitiesController < ApplicationController
  def index
    @activities = Activity.preload(:user, :trackable).newest_first
  end
end
