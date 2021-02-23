require_relative '../../environments/rspec_env'
require 'rubygems/mock_gem_ui'


RSpec.describe 'CukeSlicer, Unit' do

  let(:nodule) { CukeSlicer }


  it 'is defined' do
    expect(Kernel.const_defined?(:CukeSlicer)).to be true
  end

  describe 'the gem' do

    let(:gemspec) { eval(File.read "#{File.dirname(__FILE__)}/../../../cuke_slicer.gemspec") }

    it 'validates cleanly' do
      mock_ui = Gem::MockGemUi.new
      Gem::DefaultUserInteraction.use_ui(mock_ui) { gemspec.validate }

      expect(mock_ui.error).to_not match(/warn/i)
    end

  end

end
