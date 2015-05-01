require 'spec_helper'
require 'moon-prototype/load'

describe Fixtures::MyPrototypeObject do
  it 'should have a things class attribute' do
    expect(described_class.things).to eq(['Thingy'])
  end

  it 'should have a each_thing class method' do
    result = []
    described_class.each_thing do |str|
      result << str
    end
    expect(result).to eq(['Thingy'])
  end

  it 'should have a all_things class method' do
    expect(described_class.all_things).to eq(['Thingy'])
  end
end

describe Fixtures::MyPrototypeObjectSubClass do
  it 'should the thing class attr' do
    expect(described_class.things).to eq(['OtherThingy'])
    expect(described_class.all_things).to eq(['Thingy', 'OtherThingy'])
  end

  it 'should yield each thing' do
    result = []
    described_class.each_thing do |str|
      result << str
    end
    expect(result).to eq(['Thingy', 'OtherThingy'])
  end

  it 'should have a all_map_of_things' do
    expect(described_class.all_map_of_things).to eq({ scrap: 1, junk: 1 })
  end
end
