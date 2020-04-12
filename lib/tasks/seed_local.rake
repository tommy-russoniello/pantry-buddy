namespace(:db) do
  task(seed_local: [:environment, 'db:seed']) do
    %w[].each do |seed|
      load(Rails.root.join('db', 'seeds', "dev_#{seed}.rb"))
    end
  end
end
