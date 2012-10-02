Hosts
=====

[![Build Status](https://secure.travis-ci.org/aef/hosts.png)](
https://secure.travis-ci.org/aef/hosts)
[![Code Climate](https://codeclimate.com/badge.png)](https://codeclimate.com/github/aef/hosts)

* [Documentation][docs]
* [Project][project]

   [docs]:    http://rdoc.info/github/aef/hosts/
   [project]: https://github.com/aef/hosts/

Description
-----------

Hosts is a Ruby library able to read or manipulate the operating system's host
files. When manipulating it tries to preserve their original formatting.

Features / Problems
-------------------

This project tries to conform to:

* [Semantic Versioning (2.0.0-rc.1)][semver]
* [Ruby Packaging Standard (0.5-draft)][rps]
* [Ruby Style Guide][style]
* [Gem Packaging: Best Practices][gem]

   [semver]: http://semver.org/
   [rps]:    http://chneukirchen.github.com/rps/
   [style]:  https://github.com/bbatsov/ruby-style-guide
   [gem]:    http://weblog.rubyonrails.org/2009/9/1/gem-packaging-best-practices

Additional facts:

* Written purely in Ruby.
* Documented with YARD.
* Intended to be used with Ruby 1.8.7 or higher.
* Cryptographically signed gem and git tags.

Synopsis
--------

This documentation defines the public interface of the software. Don't rely
on elements marked as private. Those should be hidden in the documentation
by default.

This is still experimental software, even the public interface may change
substantially in future releases.

### Loading

In most cases you want to load the library by the following command:

~~~~~ ruby
require 'hosts'
~~~~~

In a bundler Gemfile you should use the following:

~~~~~ ruby
gem 'hosts'
~~~~~

### Reading a hosts file

You can either read a hosts file from the file system:

~~~~~ ruby
hosts = Hosts::File.read('/etc/hosts')
~~~~~

Or you can parse a String containing the content of a hosts file:

~~~~~ ruby
hosts = Hosts::File.parse(hosts_content)
~~~~~

### Elements

Afterwards the hosts file's elements are accessible through the elements attribute:

~~~~~ ruby
hosts.elements
# => [ #<Aef::Hosts::Entry: address="127.0.0.1" name="localhost" aliases=[] comment=nil cached!>,
#      #<Aef::Hosts::EmptyElement: cached!>,
#      #<Aef::Hosts::Entry: address="192.168.1.1" name="myhost" aliases=["myhost.mydomain"] comment=" Some comment" cached!>
# ]
~~~~~

Elements can simply be appended to the existing elements array:

~~~~~ ruby
hosts.elements << new_element
hosts.elements += new_elements
~~~~~

Or you can insert elements at specific positions:

~~~~~ ruby
hosts.elements.insert(0, new_element)
~~~~~

There are four different types of elements for a hosts file:

#### Entry

The Entry is the most common element of a hosts file. A single entry has
an address, a name and optionally an unlimited amount of alias names and a
comment.

~~~~~ ruby
Hosts::Entry.new('10.23.5.1', 'otherhost',
                 :aliases => ['otherhost.mydomain'],
                 :comment => ' A new host')
~~~~~

#### Comment

A Comment represents a line containing only a comment.

~~~~~ ruby
Hosts::Comment.new(' Nothing special')
~~~~~

#### Section

A section has a name and optionally an unlimited amount of inner elements. In
String representation a section is enclosed by easily distinguishable header
and footer

    # ----- BEGIN SECTION somename -----
    # Elements here
    # ----- END SECTION somename -----

A section is created by the following:

~~~~~ ruby
elements
# => [#<Aef::Hosts::Comment comment=" Elements here">]

section = Hosts::Section.new('somename', :elements => elements)
~~~~~

On an existing Section, elements can be modified in the same way as on a File:

~~~~~ ruby
section.elements
# => [#<Aef::Hosts::Comment comment=" Elements here">]
~~~~~

#### Empty element

Also, to represent completly empty lines without abandoning their whitespace
contents there is an EmptyElement.

~~~~~ ruby
Hosts::EmptyElement.new
~~~~~

#### Cache

When creating an element you can also specify it's String cache. This is done
automatically when reading in an existing hosts file. Should you for any reason
want to do this manually, do it like the following:

~~~~~ ruby
Hosts::EmptyElement.new(:cache => "   \t  ")
~~~~~

Note that the semantics for cache of a Section differ. See the class
documentation for this.

### Generating a String representation

To render the hosts file back into a String simply call the #to_s method:

~~~~~ ruby
hosts.to_s
# => "   127.0.0.1\tlocalhost\n   \n   192.168.1.1\tmyhost\tmyhost.mydomain\t# Some comment\n"
~~~~~

If you have read the hosts file from a file system path you can simply save it
back to this path:

~~~~~ ruby
hosts.write
~~~~~

Otherwise, if there is no known path for the file already you can specify one
for each write operation:

~~~~~ ruby
hosts.write(:path => '/tmp/hosts')
~~~~~

Or set the path for all future write operations by setting the path attribute:

~~~~~ ruby
hosts.path = '/tmp/hosts'

hosts.write
~~~~~

### String cache

Normally, if a cached String representation of an element is available, it will
be used instead of rendering a new one to preserve the overall layout of the
hosts file. If you which to generate the whole file from scratch, simply supply
the :force_generation option:

~~~~~ ruby
hosts.to_s(:force_generation => true)
# => "127.0.0.1 localhost\n\n192.168.1.1 myhost myhost.mydomain # Some comment\n"
~~~~~

Instead of temporarily ignoring the cached String representation you could also
invalidate the cache completely:

~~~~~ ruby
hosts.invalidate_cache!
~~~~~

This can also be done on single elements of the hosts file:

~~~~~ ruby
hosts.elements[1].invalidate_cache!
~~~~~

If you change attributes of an element, the cache will be cleaned
automatically:

~~~~~ ruby
hosts.elements[0].address = '127.0.1.1'
~~~~~

Requirements
------------

* Ruby 1.8.7 or higher

Installation
------------

On *nix systems you may need to prefix the command with sudo to get root
privileges.

### High security (recommended)

There is a high security installation option available through rubygems. It is
highly recommended over the normal installation, although it may be a bit less
comfortable. To use the installation method, you will need my [gem signing
public key][gemkey], which I use for cryptographic signatures on all my gems.

Add the key to your rubygems' trusted certificates by the following command:

    gem cert --add aef-gem.pem

Now you can install the gem while automatically verifying it's signature by the
following command:

    gem install hosts -P HighSecurity

Please notice that you may need other keys for dependent libraries, so you may
have to install dependencies manually.

   [gemkey]: https://aef.name/crypto/aef-gem.pem

### Normal

    gem install hosts

### Automated testing

Go into the root directory of the installed gem and run the following command
to fetch all development dependencies:

    bundle

Afterwards start the test runner:

    rake spec

If something goes wrong you should be noticed through failing examples.

Development
-----------

### Bug reports and feature requests

Please use the [issue tracker][issues] on github.com to let me know about errors
or ideas for improvement of this software.

   [issues]: https://github.com/aef/hosts/issues/

### Source code

This software is developed in the source code management system Git. There are
several synchronized mirror repositories available:

* GitHub
    
    URL: https://github.com/aef/hosts.git

* Gitorious
    
    URL: https://git.gitorious.org/hosts/hosts.git

* BitBucket
    
    URL: https://bitbucket.org/alefi/hosts.git

You can get the latest source code with the following command, while
exchanging the placeholder for one of the mirror URLs:

    git clone MIRROR_URL

#### Tags

The final commit before each released gem version will be marked by a tag
named like the version with a prefixed lower-case "v", as required by Semantic
Versioning. Every tag will be signed by my [OpenPGP public key][openpgp] which
enables you to verify your copy of the code cryptographically.

   [openpgp]: https://aef.name/crypto/aef-openpgp.asc

Add the key to your GnuPG keyring by the following command:

    gpg --import aef-openpgp.asc

This command will tell you if your code is of integrity and authentic:

    git tag -v [TAG NAME]

### Contribution

Help on making this software better is always very appreciated. If you want
your changes to be included in the official release, please clone my project
on github.com, create a named branch to commit and push your changes into and
send me a pull request afterwards.

Please make sure to write tests for your changes so that I won't break them
when changing other things on the library. Also notice that I can't promise
to include your changes before reviewing them.

License
-------

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
