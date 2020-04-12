class ItemQuantityUnit < ApplicationRecord
  belongs_to :item
  belongs_to :quantity_unit

  validates :grams, presence: true
end
