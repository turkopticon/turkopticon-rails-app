# very simple, basic implementation of a/b testing
# can only track conversions along a single dimension

module AB
  def self.table_name_prefix
    'ab_'
  end
end


require_relative 'core'
require_relative 'model'
