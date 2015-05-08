Moon Prototype
==============
[![Build Status](https://travis-ci.org/polyfox/moon-prototype.svg?branch=master)](https://travis-ci.org/polyfox/moon-prototype)
[![Test Coverage](https://codeclimate.com/github/polyfox/moon-prototype/badges/coverage.svg)](https://codeclimate.com/github/polyfox/moon-prototype)
[![Inline docs](http://inch-ci.org/github/polyfox/moon-prototype.svg?branch=master)](http://inch-ci.org/github/polyfox/moon-prototype)
[![Code Climate](https://codeclimate.com/github/polyfox/moon-prototype/badges/gpa.svg)](https://codeclimate.com/github/polyfox/moon-prototype)

This was extracted from Moon's prototype package.

## Usage
Prototypes work like class level shared variables, you can define one on the
parent class and then share values all the way down.

```ruby
require 'moon-prototype/load'

# Simply extend your class using 
class EggKeeper
  # you'll need to use the singleton class to define the attributes
  class << self
    # prototype_attr creates several methods since prototype_attrs behave like
    # collections and not single values
    # the key is pluralized using String#pluralize, your choice of inflector
    # is up to you.
    prototype_attr :egg
  end

  # By default, prototype attributes are Arrays
  eggs << 'Full White'
end

class EggKeeperJr < EggKeeper
  # Now, whats different here is, eggs is a unique array to this class
  eggs << 'Speckled White'

  eggs #=> ["Speckled White"]

  # before you say, HOW IS THIS ANY DIFFERENT FROM REGULAR VARIABLES?
  all_eggs #=> ["Full White", "Speckled White"]
  # this is where shared values come in, any changes made to one class won't
  # directly affect the others around it, you can then query for a list of
  # all the values in class's direct ancestor line.
end

class MsEggKeeper < EggKeeper
  eggs << 'Round Golden'

  all_eggs #=> ["Full White", "Round Golden"]
end
```

Have fun messing around with `Moon::Prototype` :3
