class ItemFamily < ApplicationRecord
  belongs_to :item_family, optional: true

  has_many :item_families

  static_attribute :item_family_id, alias: :item_family
  static_attribute :name
end
