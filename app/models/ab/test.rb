class AB::Test < ApplicationRecord
  has_many :variants, class_name: 'AB::Variant'
end