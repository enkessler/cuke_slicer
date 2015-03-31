require 'spec_helper'


describe 'CukeSlicer, Unit' do

  let(:nodule) { CukeSlicer }


  it 'is defined' do
    expect(Kernel.const_defined?(:CukeSlicer)).to be true
  end

end
