class AB::Variant < ApplicationRecord
  include AB::Model

  belongs_to :test, class_name: 'AB::Test'
  serialize :data, IndifferentJSON

  scope :isolate, -> (test, variant) { where(name: variant).joins(:test).where(ab_tests: { name: test }).take }
end