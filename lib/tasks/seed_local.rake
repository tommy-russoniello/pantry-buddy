namespace(:db) do
  task(seed_local: [:environment, 'db:seed']) do
    %w[measurement_units items].each do |seed|
      load(Rails.root.join('db', 'seeds', "dev_#{seed}.rb"))
    end
  end
end
