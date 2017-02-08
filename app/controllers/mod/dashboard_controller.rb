class Mod::DashboardController < ApplicationController
  before_action -> { require_access_level :moderator }

  def index
    @flags = Flag.newest.status(:open).page(1)
    @flags.each do |flag|
      unless flag.activity.empty?
        flag.activity.each { |s| s[:by] = Person.select(:display_name, :email).find(s[:by]) }
      end
    end
  end
end
