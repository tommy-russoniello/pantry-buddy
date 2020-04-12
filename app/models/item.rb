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
end
