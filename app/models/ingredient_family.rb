class ItemFamily < ApplicationRecord
  belongs_to :item_family, optional: true

  has_many :item_families
end
