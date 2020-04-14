class ItemMeasurementUnit < ApplicationRecord
  belongs_to :item
  belongs_to :measurement_unit

  validates :grams, presence: true

  static_attribute :item_id, alias: :item
  static_attribute :grams
  static_attribute :measurement_unit_id, alias: :measurement_unit
end
