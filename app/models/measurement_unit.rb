class MeasurementUnit < ApplicationRecord
  validates :name, presence: true, uniqueness: { case_sensitive: false }

  static_attribute :name

  class << self
    def standard
      return @standard if @standard

      standard_names = [
        'Ounce',
        'Gram',
        'Pound',
        'Kilogram',
        'Pinch',
        'Liter',
        'Fluid Ounce',
        'Gallon',
        'Pint',
        'Quart',
        'Milliliter',
        'Drop',
        'Cup',
        'Tablespoon',
        'Teaspoon'
      ]
      @standard = where(name: standard_names).pluck(:name, :id).to_h
    end
  end
end
