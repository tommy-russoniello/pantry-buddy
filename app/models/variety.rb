class Variety < ApplicationRecord
  validates :name, presence: true

  static_attribute :name
end
