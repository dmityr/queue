require "rake/testtask"

desc "fire tests"
task :test do |t|
  Rake::TestTask.new do |t|
    t.libs << "minitest"
    t.test_files = FileList['./test_*.rb']
    t.verbose = false
  end
end