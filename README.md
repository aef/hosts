Hosts
=====

[![Build Status](https://secure.travis-ci.org/aef/hosts.png)](
https://secure.travis-ci.org/aef/hosts)

* [Documentation][1]
* [Project][2]

   [1]: http://rdoc.info/projects/aef/hosts/
   [2]: http://github.com/aef/hosts/

Description
-----------

Hosts is a Ruby library able to read or manipulate the operating system's host
files. When manipulating it tries to preserve their original formatting.

Features / Problems
-------------------

This projects tries to conform to:

* [Semantic Versioning (2.0.0-rc.1)][5]
* [Ruby Packaging Standard (0.5-draft)][6]
* [Ruby Style Guide][7]
* [Gem Packaging: Best Practices][8]

   [5]: http://semver.org/
   [6]: http://chneukirchen.github.com/rps/
   [7]: https://github.com/bbatsov/ruby-style-guide
   [8]: http://weblog.rubyonrails.org/2009/9/1/gem-packaging-best-practices

Additional facts:

* Written purely in Ruby.
* Intended to be used with Ruby 1.8.7 or higher.

Synopsis
--------

This documentation defines the public interface of the library. Don't rely
on elements marked as private. Those should be hidden in the documentation
by default.

### Loading

In most cases you want to load the library by the following command:

~~~~~ ruby
require 'hosts'
~~~~~

In a bundler Gemfile you should use the following:

~~~~~ ruby
gem 'hosts'
~~~~~

Requirements
------------

None

Installation
------------

On *nix systems you may need to prefix the command with sudo to get root
privileges.

### High security (recommended)

There is a high security installation option available through rubygems. It is
highly recommended over the normal installation, although it may be a bit less
comfortable. To use the installation method, you will need my public key, which
I use for cryptographic signatures on all my gems. You can find the public key
here: http://aef.name/crypto/aef-gem.pem

Add the key to your rubygems' trusted certificates by the following command:

    gem cert --add aef-gem.pem

Now you can install the gem while automatically verifying it's signature by the
following command:

    gem install hosts -P HighSecurity

Please notice that you may need other keys for dependent libraries, so you may
have to install dependencies manually.  

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

This software is developed in the source code management system git hosted
at github.com. You can download the most recent sourcecode through the
following command:

    git clone https://github.com/aef/hosts.git

Help on making this software better is always very appreciated. If you want
your changes to be included in the official release, please clone my project
on github.com, create a named branch to commit and push your changes in and
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
