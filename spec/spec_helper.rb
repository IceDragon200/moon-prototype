Encoding.default_internal = Encoding.default_external = 'UTF-8'

require 'codeclimate-test-reporter'
require 'simplecov'
require 'active_support/core_ext/string/inflections'

CodeClimate::TestReporter.start
SimpleCov.start

require 'moon-prototype/load'

module Fixtures
  class MyPrototypeObject
    class << self
      prototype_attr :thing
      prototype_attr :other_thing
    end

    things << 'Thingy'
    other_things << 'Junk'
  end

  class MyPrototypeObjectSubClass < MyPrototypeObject
    things << 'OtherThingy'
    other_things << 'SomeMoreJunk'
  end
end
