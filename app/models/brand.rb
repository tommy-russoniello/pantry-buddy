class Brand < ApplicationRecord
  validates :name, presence: true

  static_attribute :name
end
