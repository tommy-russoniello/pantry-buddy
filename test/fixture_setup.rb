module FixtureSetup
  class << self
    def included(klass)
      klass.extend(ClassMethods)
    end

    def create_fixtures
      initialize_database

      create_measurement_units
      create_items
      create_item_measurement_units

      cache_data
    end

    def dirty_model?(variable_name)
      model = FixtureSetup.instance_variable_get(variable_name)
      model_cache = FixtureSetup.models[variable_name]

      # If any attributes have changed from the initial setup, then we need to
      # reload the model. We have to run two different checks to determine this.
      # The first check is a standard dirty check, which is fast but only checks
      # for unpersisted data. Most tests will make a change and then persist the
      # change, resulting in the dirty check not being sufficient. To account for
      # persisted changes, we compare the current attribute values to the values
      # set in the fixture setup. If these values are different, then we know the
      # model has changed and must be reloaded.
      #
      # We can't use just the attribute value check because of the built-in type
      # casting that ActiveRecord does. If the database defines a value as a
      # number, then all values will be cast to numbers. However, if you try to
      # set a non-numeric string value, the value will be set to 0, but the model
      # will mark the attribute as dirty and validation will fail. In this case,
      # `changed?` will return `true`.
      #
      # We also need to check if the model was destroyed because the model
      # can be destroyed without any of the attributes being changed. When
      # this happens, the model will be frozen which will cause errors if
      # we try to modify the model in another test.
      #
      # We also need to check if there are any errors left on the model. When there
      # is a validation on a model checking the data type of an attribute's value
      # (e.g., validating that an attribute's value is an integer), and a new value
      # is provided that is of an invalid type, but can be converted to the right type
      # to have the same value that the attribute originally had (e.g., attribute
      # originally having the value of `1`, while the new value is `1.0`), Rails
      # will convert the value and also add the error. This causes the model to appear
      # to not be dirty, despite having an error.
      model.changed? || model.destroyed? || model.attributes != model_cache[:attributes] ||
        model.errors.details.present?
    end

    def initialize_database
      truncate_tables(tables)
      create_seeds
    end

    def models
      @_models
    end

    def tables
      Dir[Rails.root.join('app/models/**/*.rb')].map do |path|
        model_class_name = path[%r{/(\w+)\.rb$}, 1].camelize
        require(path) unless defined?(model_class_name)
        model_class = model_class_name.constantize

        # Skip over models without tables, like `ApplicationRecord`
        next unless model_class.respond_to?(:table_name) && model_class.table_name

        model_class.table_name
      end.compact
    end

    def truncate_tables(tables)
      ApplicationRecord.connection.disable_referential_integrity do
        tables.each do |table|
          ApplicationRecord.connection.execute("DELETE FROM #{table}")
        end
      end
    end

    private

    def cache_data
      @_models = instance_variables.each_with_object({}) do |variable_name, hash|
        variable = instance_variable_get(variable_name)
        next unless variable.is_a?(ApplicationRecord)

        hash[variable_name] = {
          attributes: variable.attributes,
          relations: variable.class.reflect_on_all_associations(:has_many).map(&:name)
        }
      end
    end

    def create_items
      @item = Item.create!(
        added_sugar: 1,
        calcium: 1,
        calories: 100,
        carbs: 1,
        cholesterol: 1,
        edamam_id: 'edamam id',
        fat: 1,
        fdc_id: 'fdc id',
        fiber: 1,
        health_label_ids: [HealthLabel.ids[:vegan]],
        iron: 1,
        magnesium: 1,
        monounsaturated_fat: 1,
        name: 'item',
        niacin: 1,
        phosphorus: 1,
        polyunsaturated_fat: 1,
        potassium: 1,
        protein: 1,
        riboflavin: 1,
        saturated_fat: 1,
        sodium: 1,
        sugar: 1,
        thiamin: 1,
        trans_fat: 1,
        upc: 'upc',
        vitamin_a: 1,
        vitamin_b6: 1,
        vitamin_b12: 1,
        vitamin_c: 1,
        vitamin_d: 1,
        vitamin_e: 1,
        vitamin_k: 1
      )

      @other_item = Item.create!(
        added_sugar: 1,
        calcium: 1,
        calories: 100,
        carbs: 1,
        cholesterol: 1,
        edamam_id: 'other edamam id',
        fat: 1,
        fdc_id: 'other fdc id',
        fiber: 1,
        health_label_ids: [HealthLabel.ids[:vegan]],
        iron: 1,
        magnesium: 1,
        monounsaturated_fat: 1,
        name: 'other item',
        niacin: 1,
        phosphorus: 1,
        polyunsaturated_fat: 1,
        potassium: 1,
        protein: 1,
        riboflavin: 1,
        saturated_fat: 1,
        sodium: 1,
        sugar: 1,
        thiamin: 1,
        trans_fat: 1,
        upc: 'other upc',
        vitamin_a: 1,
        vitamin_b6: 1,
        vitamin_b12: 1,
        vitamin_c: 1,
        vitamin_d: 1,
        vitamin_e: 1,
        vitamin_k: 1
      )
    end

    def create_item_measurement_units
      @item_measurement_unit = ItemMeasurementUnit.create!(
        grams: 1,
        item: @item,
        measurement_unit: @measurement_unit
      )

      @other_item_measurement_unit = ItemMeasurementUnit.create!(
        grams: 1,
        item: @other_item,
        measurement_unit: @other_measurement_unit
      )
    end

    def create_measurement_units
      @measurement_unit = MeasurementUnit.create!(
        name: 'measurement unit'
      )

      @other_measurement_unit = MeasurementUnit.create!(
        name: 'other measurement unit'
      )
    end

    def create_seeds
      load(Rails.root.join('db/seeds.rb'))
    end
  end

  def setup
    FixtureSetup.instance_variables.each do |variable_name|
      variable = FixtureSetup.instance_variable_get(variable_name)

      # Reload models back to their original state (the database is automatically
      # reset before each test run). Even though this is faster than rebuilding
      # all of the models for each test, it's still fairly slow. To speed this up
      # even more, we attempt to only reload the dirty models.
      #
      # Detecting dirty models isn't too easy since we persist the changes in our
      # tests. Since there's no direct way to do this dirty checking, we implement
      # a few different checks, falling back to reloading if we can't be 100% sure
      # that the model isn't dirty.
      if variable.is_a?(ApplicationRecord)
        model_cache = FixtureSetup.models[variable_name]

        # We always want to use `reload` for dirty models, instead of reassigning
        # the variable after reinstantiating it, so that any cached associations
        # get reloaded as well. For example, `@item_measurement_unit` has `item` set
        # to `@item` in the fixture setup. If a test causes `@item` to
        # become dirty, calling `reload` on the model will cause
        # `@item_measurement_unit.item` to reload as well, since it's just a pointer
        # to the same instance as `@item`. However, if we reinstantiate the
        # model and then assign it to the variable, we would end up running
        # `@item = Item.find(@item.id)` which would make `@item`
        # clean again, but `@item_measurement_unit.item` would still have the cached,
        # dirty instance of `@item` from the previous test run.
        if FixtureSetup.dirty_model?(variable_name)
          # We use a custom reload method to handle deleted models
          variable.reload_for_tests
        else
          # If the attributes aren't dirty, the relations may be, so we reset all
          # `has_many` relations. Calling `reset` will clear the cache for the
          # relation without querying for new data. Any `belongs_to` relations will
          # have been reset via the `reload` above since they are exposed via
          # `attributes`.
          #
          # NOTE: `has_one` relations may be problematic, but we don't currently
          # have any `has_one` relations.
          model_cache[:relations].each do |relation|
            variable.send(relation).reset
          end
        end
      end

      instance_variable_set(variable_name, variable)
    end
  end

  module ClassMethods
    def tests_for(name)
      @test_group = name
      yield
    end

    def test_invalid_changes(record_name, scenarios, options = {})
      scenarios.each do |scenario|
        begin
          if scenario.is_a?(Array)
            attribute = attribute_alias = scenario.first
            value = scenario[1]
            errors = error_messages = scenario[2]
            if scenario.size > 3
              pre = scenario.last[:pre]
              post = scenario.last[:post]
            end

            pre ||= options[:pre]
            post ||= options[:post]
          else
            attribute = scenario[:attribute]
            value = scenario[:value]
            errors = error_messages = scenario[:errors]
            pre = scenario[:pre] || options[:pre]
            post = scenario[:post] || options[:post]
          end
        rescue StandardError
          raise(ArgumentError, 'invalid test scenarios')
        end

        if errors.is_a?(Hash)
          error_messages =
            errors.map { |field, messages| "(#{field}: #{messages.join(', ')})" }.join(' ')
        else
          if /_id$/.match?(attribute)
            maybe_alias = attribute[0...-3]
            maybe_model = maybe_alias.camelize.safe_constantize
            attribute_alias = maybe_alias if maybe_model && maybe_model < ApplicationRecord
          end

          errors = { attribute_alias.to_sym => [errors] }
        end

        string_value =
          if value.is_a?(String)
            "'#{value}'"
          elsif value.nil?
            'nil'
          else
            value.to_s
          end

        test_name = "test_#{@test_group}_#{attribute_alias}_#{string_value}_#{error_messages}"
          .gsub(/[-\s]+/, '_')

        test_name << "_[pre:#{pre.__id__}]" if pre
        test_name << "_[post:#{post.__id__}]" if post

        raise("#{test_name} is already defined in #{self}") if method_defined?(test_name)

        define_method("_#{test_name}") do
          instance_eval(&pre) if pre

          record = instance_variable_get(record_name)
          record.save if options[:save]
          value = instance_eval(value.to_s) if value.is_a?(Symbol) && value.match?(/^@/)
          record.send("#{attribute}=", value)

          instance_eval(&post) if post

          assert_not(record.save, 'not valid')
          assert_equal(errors, record.errors.messages, 'error messages')
        end

        class_eval(<<-RUBY, __FILE__, __LINE__ + 1)
          define_method("#{test_name}") do
            method("_#{test_name}").call
          end
        RUBY
      end
    end
  end

  # Reloading a model after it has been destroyed does not reset the `@destroyed`
  # flag, presumably because this is not a normal scenario that should occur.
  # However, we rely on being able to reload destroyed models in our tests after
  # the database has been restored.
  class ::ApplicationRecord
    def reload_for_tests
      @destroyed = false
      reload
      errors.clear
    end
  end
end
