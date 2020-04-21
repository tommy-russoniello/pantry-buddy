class MeasurementUnit < ApplicationRecord
  before_create :set_default_uri_fragment_suffix

  validates :name, presence: true, uniqueness: { case_sensitive: false }

  static_attribute :name
  static_attribute :uri_fragment_suffix

  class << self
    def custom
      where.not(id: standard.values)
    end

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

  private

  def set_default_uri_fragment_suffix
    self.uri_fragment_suffix ||= name.parameterize.underscore
  end
end
