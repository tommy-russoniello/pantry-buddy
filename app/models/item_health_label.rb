class ItemHealthLabel < ApplicationRecord
  belongs_to :health_label
  belongs_to :item

  static_attribute :health_label_id, alias: :health_label
  static_attribute :item_id, alias: :item
end
