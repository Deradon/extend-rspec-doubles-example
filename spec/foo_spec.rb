require 'spec_helper'

describe Foo do
  it 'has a version number' do
    expect(Foo::VERSION).not_to be nil
  end

  it 'does something useful' do
    expect(false).to eq(true)
  end
end
