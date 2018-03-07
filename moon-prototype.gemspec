require 'date'
require_relative 'lib/moon-prototype/version'

Gem::Specification.new do |s|
  s.name        = 'moon-prototype'
  s.summary     = 'Moon Prototype package.'
  s.description = 'Moon Prototype package, extracted the moon-packages.'
  s.homepage    = 'https://github.com/polyfox/moon-prototype'
  s.email       = 'mistdragon100@gmail.com'
  s.version     = Moon::Prototype::Version::STRING
  s.platform    = Gem::Platform::RUBY
  s.date        = Time.now.to_date.to_s
  s.license     = 'MIT'
  s.authors     = ['Blaž Hrastnik', 'Corey Powell']

  s.add_dependency             'activesupport',  ['>= 4.2', '< 6.0']
  s.add_development_dependency 'rake',           '>= 11.0'
  s.add_development_dependency 'yard',           '~> 0.9.12'
  s.add_development_dependency 'rspec',          '~> 3.2'
  s.add_development_dependency 'simplecov'

  s.require_path = 'lib'
  s.files = []
  s.files += Dir.glob('lib/**/*.{rb,yml}')
  s.files += Dir.glob('spec/**/*')
end
