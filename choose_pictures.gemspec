# Note: this file is basically just testing that, yep, I can create a
# gem. It is unlikely that I would actually publish a gem for this
# project.

Gem::Specification.new do |spec|
  spec.name = 'choose_pictures'
  spec.version = '0.0.0'
  spec.summary = 'Visual helper for copying pictures to another directory'
  spec.description = ('GUI for choosing pictures via keyboard to a group ' +
                      'and then copying them to a separate directory')
  spec.authors = ['Marko Raatikainen']
  spec.files = Dir.glob('lib/*.rb') + Dir.glob('lib/*.qml')
  spec.executables = 'choose_pictures'
  spec.homepage = 'https://github.com/byon/choose-pictures'
  spec.license = 'MIT'

  spec.add_runtime_dependency 'qml', '~> 0.0.7'

  spec.add_development_dependency 'rake', '~> 10.4'
  spec.add_development_dependency 'rspec', '~> 3.2'
end
