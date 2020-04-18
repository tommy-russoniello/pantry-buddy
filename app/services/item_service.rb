class ItemService
  class << self
    def create_item_from_upc(upc)
      data = Edamam.get_nutrition_data_from_upc(upc)
      return unless data

      health_label_ids = HealthLabel
        .ids
        .values_at(*data[:health_labels].map { |health_label| health_label.downcase.to_sym })
        .compact

      custom_measurement_unit_names =
        data[:measurement_units].except(*MeasurementUnit.standard.keys)

      custom_measurement_units =
        MeasurementUnit.where(name: custom_measurement_unit_names.keys).to_a
      new_measurement_unit_names =
        custom_measurement_unit_names.keys - custom_measurement_units.map(&:name)

      ApplicationRecord.transaction do
        new_measurement_unit_names.each do |new_measurement_unit_name|
          custom_measurement_units << MeasurementUnit.create!(
            name: new_measurement_unit_name,
            uri_fragment_suffix: custom_measurement_unit_names[new_measurement_unit_name]
          )
        end

        item = Item.create!(
          grams_per_tablespoon: data[:grams_per_tablespoon],
          health_label_ids: health_label_ids,
          name: data[:name],
          upc: upc,
          **data[:nutrients]
        )

        custom_measurement_units.each do |custom_measurement_unit|
          ItemMeasurementUnit.create!(
            grams: Edamam.get_grams_per_measurement_unit(
              food_id: data[:food_id],
              measurement_name: custom_measurement_unit.uri_fragment_suffix
            ),
            item: item,
            measurement_unit_id: custom_measurement_unit.id
          )
        end
      end
    end
  end
end
