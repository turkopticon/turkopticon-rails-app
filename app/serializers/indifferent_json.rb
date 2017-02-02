# custom serializer for ActiveRecord
# allows using symbols to access json keys when loading from jsonb data type

class IndifferentJSON
  def self.dump(hash)
    hash.as_json
  end

  def self.load(jsonb)
    (jsonb || {}).with_indifferent_access
  end
end