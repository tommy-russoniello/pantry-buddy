class Item < ApplicationRecord
  has_many :item_health_labels
  has_many :item_measurement_units

  has_many :health_labels, through: :item_health_labels
  has_many :measurement_units, through: :item_measurement_units

  validates :name, presence: true

  static_attribute :edamam_id, once_set: true
  static_attribute :fdc_id, once_set: true
  static_attribute :upc

  def self.nutrients
    %i[
      added_sugar
      calcium
      calories
      carbs
      cholesterol
      fat
      fiber
      iron
      magnesium
      monounsaturated_fat
      niacin
      phosphorus
      polyunsaturated_fat
      potassium
      protein
      riboflavin
      saturated_fat
      sodium
      sugar
      thiamin
      trans_fat
      vitamin_a
      vitamin_b6
      vitamin_b12
      vitamin_c
      vitamin_d
      vitamin_e
      vitamin_k
    ]
  end

  nutrients.each do |nutrient|
    validates(nutrient, allow_nil: true, numericality: { greater_than_or_equal_to: 0 })
  end

  def clear_nutrients
    self.class.nutrients.each { |nutrient| send("#{nutrient}=", nil) }
  end
end
