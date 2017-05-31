Encoding.default_internal = Encoding.default_external = 'UTF-8'

require 'simplecov'
require 'active_support/core_ext/string/inflections'

SimpleCov.start

require 'moon-prototype/load'

module Fixtures
  module ExtensionPrototype
    prototype_attr :exts
  end

  class MyPrototypeObject
    extend ExtensionPrototype

    class << self
      prototype_attr :thing
      prototype_attr :other_thing,  default: proc { Array.new }
      prototype_attr :map_of_thing, type: Hash
    end

    exts << :main
    things << 'Thingy'
    other_things << 'Junk'
    map_of_things[:scrap] = 1
  end

  class MyPrototypeObjectSubClass < MyPrototypeObject
    exts << :sub
    things << 'OtherThingy'
    other_things << 'SomeMoreJunk'
    map_of_things[:junk] = 1
  end
end
