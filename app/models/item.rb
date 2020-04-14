class Item < ApplicationRecord
  validates :added_sugar, allow_nil: true, numericality: { greater_than_or_equal_to: 0 }
  validates :calcium, allow_nil: true, numericality: { greater_than_or_equal_to: 0 }
  validates :calories, allow_nil: true, numericality: { greater_than_or_equal_to: 0 }
  validates :carbs, allow_nil: true, numericality: { greater_than_or_equal_to: 0 }
  validates :cholesterol, allow_nil: true, numericality: { greater_than_or_equal_to: 0 }
  validates :fat, allow_nil: true, numericality: { greater_than_or_equal_to: 0 }
  validates :fiber, allow_nil: true, numericality: { greater_than_or_equal_to: 0 }
  validates :iron, allow_nil: true, numericality: { greater_than_or_equal_to: 0 }
  validates :magnesium, allow_nil: true, numericality: { greater_than_or_equal_to: 0 }
  validates :monounsaturated_fat, allow_nil: true, numericality: { greater_than_or_equal_to: 0 }
  validates :name, presence: true
  validates :niacin, allow_nil: true, numericality: { greater_than_or_equal_to: 0 }
  validates :phosphorus, allow_nil: true, numericality: { greater_than_or_equal_to: 0 }
  validates :polyunsaturated_fat, allow_nil: true, numericality: { greater_than_or_equal_to: 0 }
  validates :potassium, allow_nil: true, numericality: { greater_than_or_equal_to: 0 }
  validates :protein, allow_nil: true, numericality: { greater_than_or_equal_to: 0 }
  validates :riboflavin, allow_nil: true, numericality: { greater_than_or_equal_to: 0 }
  validates :saturated_fat, allow_nil: true, numericality: { greater_than_or_equal_to: 0 }
  validates :sodium, allow_nil: true, numericality: { greater_than_or_equal_to: 0 }
  validates :sugar, allow_nil: true, numericality: { greater_than_or_equal_to: 0 }
  validates :thiamin, allow_nil: true, numericality: { greater_than_or_equal_to: 0 }
  validates :trans_fat, allow_nil: true, numericality: { greater_than_or_equal_to: 0 }
  validates :vitamin_a, allow_nil: true, numericality: { greater_than_or_equal_to: 0 }
  validates :vitamin_b6, allow_nil: true, numericality: { greater_than_or_equal_to: 0 }
  validates :vitamin_b12, allow_nil: true, numericality: { greater_than_or_equal_to: 0 }
  validates :vitamin_c, allow_nil: true, numericality: { greater_than_or_equal_to: 0 }
  validates :vitamin_d, allow_nil: true, numericality: { greater_than_or_equal_to: 0 }
  validates :vitamin_e, allow_nil: true, numericality: { greater_than_or_equal_to: 0 }
  validates :vitamin_k, allow_nil: true, numericality: { greater_than_or_equal_to: 0 }

  static_attribute :name
end
