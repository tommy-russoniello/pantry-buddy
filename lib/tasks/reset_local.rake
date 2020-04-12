namespace(:db) do
  task(reset_local: ['db:drop', 'db:create']) do
    # When we recreate and seed the database all in one task, it is possible for the
    # `@attribute_names` instance variable on ActiveRecords to become empty (`[]`) and stay
    # that way even once we reach seeding. Since the `attribute_names` method on ActiveRecords
    # will only try to get a fresh value for the instance variable if it is `nil`, an empty
    # array as the value will prevent the method from ever getting a fresh value. This causes
    # problems later on during seeding when the ActiveRecord's attributes do not match its
    # attribute names, leaving us to be unable to do certain things such as calling `super`
    # in an ActiveRecord attribute reader/writer. So before we move on to setting up the
    # database after recreating it, we clear out this instance variable for all of our models.
    Dir[Rails.root.join('app/models/**/*.rb')].map do |path|
      model_class_name = path[%r{/(\w+)\.rb$}, 1].camelize
      require(path) unless defined?(model_class_name)
      model_class = model_class_name.constantize

      # Skip over models without tables like `ApplicationRecord`
      next unless model_class.respond_to?(:table_name) && model_class.table_name

      model_class.instance_variable_set(:@attribute_names, nil)
    end

    Rake::Task['db:setup_local'].invoke
  end
end
