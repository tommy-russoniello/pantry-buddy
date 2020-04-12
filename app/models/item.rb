class Item < ApplicationRecord
  belongs_to :brand
  belongs_to :item_family
  belongs_to :variety

  validates :added_sugar, numericality: { greater_than_or_equal_to: 0 }, presence: true
  validates :calcium, numericality: { greater_than_or_equal_to: 0 }, presence: true
  validates :calories, numericality: { greater_than_or_equal_to: 0 }, presence: true
  validates :carbs, numericality: { greater_than_or_equal_to: 0 }, presence: true
  validates :cholesterol, numericality: { greater_than_or_equal_to: 0 }, presence: true
  validates :fat, numericality: { greater_than_or_equal_to: 0 }, presence: true
  validates :fiber, numericality: { greater_than_or_equal_to: 0 }, presence: true
  validates :folate, numericality: { greater_than_or_equal_to: 0 }, presence: true
  validates :iron, numericality: { greater_than_or_equal_to: 0 }, presence: true
  validates :magnesium, numericality: { greater_than_or_equal_to: 0 }, presence: true
  validates :monounsaturated_fat, numericality: { greater_than_or_equal_to: 0 }, presence: true
  validates :name, presence: true
  validates :niacin, numericality: { greater_than_or_equal_to: 0 }, presence: true
  validates :phosphorus, numericality: { greater_than_or_equal_to: 0 }, presence: true
  validates :polyunsaturated_fat, numericality: { greater_than_or_equal_to: 0 }, presence: true
  validates :potassium, numericality: { greater_than_or_equal_to: 0 }, presence: true
  validates :protein, numericality: { greater_than_or_equal_to: 0 }, presence: true
  validates :riboflavin, numericality: { greater_than_or_equal_to: 0 }, presence: true
  validates :saturated_fat, numericality: { greater_than_or_equal_to: 0 }, presence: true
  validates :sodium, numericality: { greater_than_or_equal_to: 0 }, presence: true
  validates :sugar, numericality: { greater_than_or_equal_to: 0 }, presence: true
  validates :thiamin, numericality: { greater_than_or_equal_to: 0 }, presence: true
  validates :trans_fat, numericality: { greater_than_or_equal_to: 0 }, presence: true
  validates :vitamin_a, numericality: { greater_than_or_equal_to: 0 }, presence: true
  validates :vitamin_b6, numericality: { greater_than_or_equal_to: 0 }, presence: true
  validates :vitamin_b12, numericality: { greater_than_or_equal_to: 0 }, presence: true
  validates :vitamin_c, numericality: { greater_than_or_equal_to: 0 }, presence: true
  validates :vitamin_d, numericality: { greater_than_or_equal_to: 0 }, presence: true
  validates :vitamin_e, numericality: { greater_than_or_equal_to: 0 }, presence: true
  validates :vitamin_k, numericality: { greater_than_or_equal_to: 0 }, presence: true

  static_attribute :added_sugar
  static_attribute :brand_id, alias: :brand
  static_attribute :calcium
  static_attribute :calories
  static_attribute :carbs
  static_attribute :cholesterol
  static_attribute :fat
  static_attribute :fiber
  static_attribute :folate
  static_attribute :iron
  static_attribute :item_family_id, alias: :item_family
  static_attribute :magnesium
  static_attribute :monounsaturated_fat
  static_attribute :name
  static_attribute :niacin
  static_attribute :phosphorus
  static_attribute :polyunsaturated_fat
  static_attribute :potassium
  static_attribute :protein
  static_attribute :riboflavin
  static_attribute :saturated_fat
  static_attribute :sodium
  static_attribute :sugar
  static_attribute :thiamin
  static_attribute :trans_fat
  static_attribute :vitamin_a
  static_attribute :vitamin_b6
  static_attribute :vitamin_b12
  static_attribute :vitamin_c
  static_attribute :vitamin_d
  static_attribute :vitamin_e
  static_attribute :vitamin_k
  static_attribute :variety_id, alias: :variety
end
