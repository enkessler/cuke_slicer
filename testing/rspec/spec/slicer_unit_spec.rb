require_relative '../../environments/rspec_env'


RSpec.describe 'Slicer, Unit' do

  let(:clazz) { CukeSlicer::Slicer }
  let(:slicer) { clazz.new }


  it 'is defined' do
    expect(CukeSlicer.const_defined?(:Slicer)).to be true
  end

  it 'can slice individual test cases out of a larger group' do
    expect(slicer).to respond_to(:slice)
  end

  it 'needs something to slice up, an output format, and can optionally have applicable filters' do
    expect(slicer.method(:slice).arity).to eq(-3)
  end

  it 'knows what slice filters are available for use' do
    expect(clazz).to respond_to(:known_filters)
  end

  it 'tracks its filters as an array of symbols' do
    filters = clazz.known_filters

    expect(filters).to be_an(Array)
    expect(filters).to_not be_empty

    filters.each do |filter|
      expect(filter).to be_a(Symbol)
    end
  end

end
