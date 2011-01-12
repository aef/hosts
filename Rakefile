# -*- ruby -*-

$LOAD_PATH.unshift('lib')

require 'hoe'
require 'aef/hosts'

Hoe.spec 'hosts' do
  developer('Alexander E. Fischer', 'aef@raxys.net')

  extra_dev_deps << ['rspec', '>= 2.2.0']

  self.rubyforge_name = 'aef'
  self.url = 'https://rubyforge.org/projects/aef/'
  self.readme_file = 'README.rdoc'
  self.extra_rdoc_files = %w{README.rdoc}
  self.spec_extras = {
    :rdoc_options => ['--main', 'README.rdoc', '--inline-source', '--line-numbers', '--title', 'Hosts']
  }
end

# vim: syntax=ruby
