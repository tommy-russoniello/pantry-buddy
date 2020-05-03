class ItemService
  NUTRITION_DATA_COLLECTION_RETRY_DURATION = 1.month.freeze

  class << self
    def find_or_create_item_from_upc(upc)
      item = Item.find_by(upc: upc)
      if item
        if item.edamam_id
          date = item.nutrition_data_collection_failed_at
          return item if !date || date > NUTRITION_DATA_COLLECTION_RETRY_DURATION.ago

          create_data_from_fdc(item)
        else
          create_data_from_edamam(item)
        end

        item.reload
      else
        new_item = create_data_from_fdc(upc)
        create_data_from_edamam(new_item || upc)
      end
    end

    private

    def create_data_from_edamam(value)
      upc =
        if value.is_a?(Item)
          item = value
          item.upc
        else
          value
        end

      data = Edamam.get_data_from_upc(upc, nutrients: item.nil?)
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

      begin
        ApplicationRecord.transaction do
          new_measurement_unit_names.each do |new_measurement_unit_name|
            custom_measurement_units << MeasurementUnit.create!(
              name: new_measurement_unit_name,
              uri_fragment_suffix: custom_measurement_unit_names[new_measurement_unit_name]
            )
          end

          item ||= Item.new(
            name: data[:name],
            upc: upc,
            **data[:nutrients]
          )

          item.update!(
            grams_per_tablespoon: data[:grams_per_tablespoon],
            health_label_ids: health_label_ids
          )

          custom_measurement_units.each do |custom_measurement_unit|
            ItemMeasurementUnit.create!(
              grams: Edamam.get_grams_per_measurement_unit(
                edamam_id: data[:edamam_id],
                measurement: custom_measurement_unit.uri_fragment_suffix
              ),
              item: item,
              measurement_unit_id: custom_measurement_unit.id
            )
          end
        end

        item
      rescue StandardError
        nil
      end
    end

    def create_data_from_fdc(value)
      upc =
        if value.is_a?(Item)
          item = value
          item.upc
        else
          value
        end

      data = Fdc.get_data_from_upc(upc)
      unless data
        item&.update(nutrition_data_collection_failed_at: Time.zone.now)
        return
      end

      begin
        if item
          item.clear_nutrients
          item.update!(fdc_id: data[:fdc_id], name: data[:name], **data[:nutrients])
        else
          Item.create!(fdc_id: data[:fdc_id], name: data[:name], upc: upc, **data[:nutrients])
        end
      rescue StandardError
        item&.update(nutrition_data_collection_failed_at: Time.zone.now)
        nil
      end
    end
  end
end
