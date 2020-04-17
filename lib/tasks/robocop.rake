require 'rubocop/rake_task'

desc('Run RuboCop')
RuboCop::RakeTask.new(:rubocop) do |task|
  task.requires << 'rubocop-rails'
  [
    'test/rubo_cop/cop/style/method_call_with_args_parentheses.rb'
  ].each do |override|
    task.requires << Rails.root.join(override).to_s
  end

  directories = %w[app config db lib scripts test]
  task.patterns = FileList.new(directories.map { |path| "#{path}/**/*.rb" })
    .include('Rakefile')
    .include('lib/tasks/**/*.rake')
    .exclude('lib/templates/**/*')
    .exclude('db/schema.rb')
  task.options = %w[--display-cop-names]
end
