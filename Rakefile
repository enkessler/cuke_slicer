require 'bundler/gem_tasks'
require 'rake'
require 'racatt'
require 'coveralls/rake/task'
require 'rainbow'


Rainbow.enabled = true

namespace 'racatt' do
  Racatt.create_tasks
end


namespace 'cuke_slicer' do

  desc 'Removes the current code coverage data'
  task :clear_coverage do
    code_coverage_directory = "#{File.dirname(__FILE__)}/coverage"

    FileUtils.remove_dir(code_coverage_directory, true)
  end

  desc 'Check documentation with RDoc'
  task :check_documentation do
    output = `rdoc lib -C`
    puts output

    if output =~ /100.00% documented/
      puts Rainbow('All code documented').green
    else
      raise Rainbow('Parts of the gem are undocumented').red
    end
  end

  desc 'Check documentation with RDoc'
  task :check_for_outdated_dependencies do
    output = `bundle outdated`
    puts output

    if output =~ /requested/
      raise Rainbow('Some dependencies are out of date!').red
    else
      puts Rainbow('All direct dependencies up to date!').green
    end
  end

  desc 'Run all of the tests'
  task :test_everything => [:clear_coverage] do
    rspec_args = '--tag ~@wip --pattern "spec/**/*_spec.rb" --force-color'

    cucumber_version = Gem.loaded_specs['cucumber'].version.version

    if cucumber_version =~ /^[123]\./
      cucumber_args = 'features -f progress -t ~@wip --color'
    else
      cucumber_args = "features -f progress -t 'not @wip' --color"
    end

    Rake::Task['racatt:test_everything'].invoke(rspec_args, cucumber_args)
  end

  # creates coveralls:push task
  Coveralls::RakeTask.new

  desc 'The task that CI will run. Do not run locally.'
  task :ci_build => ['cuke_slicer:test_everything', 'coveralls:push']

  desc 'Check that things look good before trying to release'
  task :prerelease_check do
    begin
      Rake::Task['cuke_slicer:test_everything'].invoke
      Rake::Task['cuke_slicer:check_documentation'].invoke
    rescue => e
      puts Rainbow("Something isn't right!").red
      raise e
    end

    puts Rainbow('All is well. :)').green
  end

end


task :default => 'cuke_slicer:test_everything'
