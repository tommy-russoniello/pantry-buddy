namespace(:db) do
  task(setup_local: ['db:schema:load', 'db:seed_local']) {}
end
