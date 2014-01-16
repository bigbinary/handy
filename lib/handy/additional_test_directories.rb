# Adding test/services directory to the rake test.
namespace :test do
  desc "Test services code"
  Rake::TestTask.new(:services) do |t|
    t.libs << "test"
    t.pattern = 'test/services/**/*_test.rb'
    t.verbose = true
  end
end
Rake::Task[:test].enhance { Rake::Task["test:services"].invoke }

# Adding test/workers directory to the rake test.
namespace :test do
  desc "Test workers code"
  Rake::TestTask.new(:workers) do |t|
    t.libs << "test"
    t.pattern = 'test/workers/**/*_test.rb'
    t.verbose = true
  end
end
Rake::Task[:test].enhance { Rake::Task["test:workers"].invoke }

# Adding test/carriers directory to the rake test.
namespace :test do
  desc "Test carriers code"
  Rake::TestTask.new(:carriers) do |t|
    t.libs << "test"
    t.pattern = 'test/carriers/**/*_test.rb'
    t.verbose = true
  end
end
Rake::Task[:test].enhance { Rake::Task["test:carriers"].invoke }
