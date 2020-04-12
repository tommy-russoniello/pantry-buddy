class ItemQuantityUnit < ApplicationRecord
  belongs_to :item
  belongs_to :quantity_unit

  validates :grams, presence: true

  static_attribute :item_id, alias: :item
  static_attribute :grams
  static_attribute :quantity_unit_id, alias: :quantity_unit
end
