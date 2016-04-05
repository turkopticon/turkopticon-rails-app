class RulesVersion < ActiveRecord::Base
  def parent
    RulesVersion.find(parent_id)
  end
  def self.current
    RulesVersion.find_all_by_is_current(true).last
  end
end
