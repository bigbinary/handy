# Adding test/services directory to the rake test.
namespace :test do
  desc "Test services code"
  Rails::TestTask.new(services: 'test:prepare') do |t|
    t.pattern = 'test/services/**/*_test.rb'
  end
end

# Adding test/workers directory to the rake test.
namespace :test do
  desc "Test workers code"
  Rails::TestTask.new(workers: 'test:prepare') do |t|
    t.pattern = 'test/workers/**/*_test.rb'
  end
end

# Adding test/carriers directory to the rake test.
namespace :test do
  desc "Test carriers code"
  Rails::TestTask.new(carriers: 'test:prepare') do |t|
    t.pattern = 'test/carriers/**/*_test.rb'
  end
end

Rake::Task['test:run'].enhance ["test:services", "test:carriers", "test:workers"]
