# encoding: UTF-8
=begin
Copyright Alexander E. Fischer <aef@raxys.net>, 2012

This file is part of Hosts.

Permission to use, copy, modify, and/or distribute this software for any
purpose with or without fee is hereby granted, provided that the above
copyright notice and this permission notice appear in all copies.

THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH
REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND
FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT,
INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM
LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR
OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR
PERFORMANCE OF THIS SOFTWARE.
=end

require File.expand_path('../lib/aef/hosts/version', __FILE__)

Gem::Specification.new do |s|
  s.name        = 'hosts'
  s.version     = Aef::Hosts::VERSION.dup
  s.authors     = ['Alexander E. Fischer']
  s.email       = ['aef@raxys.net']
  s.homepage    = 'http://github.com/aef/hosts'
  s.license     = 'ISC'
  s.summary     = 'Host file manipulation for Ruby.'
  s.description = <<-DESCRIPTION
Hosts is a Ruby library able to read or manipulate the operating system's host
files. When manipulating it tries to preserve their original formatting.
  DESCRIPTION

  s.rubyforge_project = nil
  s.has_rdoc          = 'yard'
  s.extra_rdoc_files  = ['HISTORY.md', 'LICENSE.md'] 

  s.files         = `git ls-files`.lines.map(&:chomp)
  s.test_files    = `git ls-files -- {test,spec,features}/*`.lines.map(&:chomp)
  s.executables   = `git ls-files -- bin/*`.lines.map{|f| File.basename(f.chomp) }
  s.require_paths = ["lib"]

  s.required_ruby_version = '>= 1.8.7'

  s.add_dependency('activemodel', '~> 3.2.1')
  s.add_dependency('linebreak', '~> 2.0.0')

  s.add_development_dependency('bundler', '~> 1.0.21')
  s.add_development_dependency('rake', '~> 0.9.2')
  s.add_development_dependency('rspec', '~> 2.8.0')
  s.add_development_dependency('simplecov', '~> 0.6.1')
  s.add_development_dependency('pry', '~> 0.9.8')
  s.add_development_dependency('yard', '~> 0.7.5')

  s.cert_chain = "#{ENV['GEM_CERT_CHAIN']}".split(':')
  s.signing_key = ENV['GEM_SIGNING_KEY']
end
