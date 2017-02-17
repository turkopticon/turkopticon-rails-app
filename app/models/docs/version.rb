class Docs::Version < ApplicationRecord
  belongs_to :document, class_name: 'Docs::Document'
end