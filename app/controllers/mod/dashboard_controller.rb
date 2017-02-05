class Mod::DashboardController < ApplicationController
  # before_action -> { require_access_level :moderator }
  def index
    @flags = Flag.newest.status(:open).page(1)
    @flags.each do |flag|
      unless flag.activity.empty? || flag.activity[:status].nil?
        flag.activity[:status].each { |s| s[:by] = Person.find(s[:by]) }
      end
    end
  end
end
