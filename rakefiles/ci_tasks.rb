require 'coveralls/rake/task'

namespace 'cuke_slicer' do

  # Creates coveralls:push task
  Coveralls::RakeTask.new

  desc 'The task that CI will run. Do not run locally.'
  task :ci_build => ['cuke_slicer:full_check', 'coveralls:push'] # rubocop:disable Style/HashSyntax

end
