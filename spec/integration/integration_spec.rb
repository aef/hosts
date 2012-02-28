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

require 'spec_helper'

describe 'Hosts library' do
  it "should be able to interpret a Windows hosts file" do
    @fixture_file = fixtures_dir + 'windows_hosts'
    @file = Aef::Hosts::File.new(@fixture_file)

    @file.read

    @file.elements.each_with_index do |element, index|
      line_number = index + 1
      case line_number
      when 1
        element.should be_a(Aef::Hosts::Comment)
        element.comment.should == " A comment"
        element.to_s.should    ==
          "# A comment\n"
        element.to_s(:force_generation => true).should ==
          "# A comment\n"
      when 2
        element.should be_a(Aef::Hosts::Entry)
        element.address.should == "102.54.94.97"
        element.name.should == "rhino.acme.com"
        element.aliases.should be_empty
        element.comment.should == " source server"
        element.to_s.should == 
          "      102.54.94.97     rhino.acme.com          # source server\n"
        element.to_s(:force_generation => true).should ==
          "102.54.94.97 rhino.acme.com # source server\n"
      when 3
        element.should be_a(Aef::Hosts::Entry)
        element.address.should == "38.25.63.10"
        element.name.should == "x.acme.com"
        element.aliases.should be_empty
        element.comment.should == " x client host"
        element.to_s.should ==
          "       38.25.63.10     x.acme.com              # x client host\n"
        element.to_s(:force_generation => true).should ==
          "38.25.63.10 x.acme.com # x client host\n"
      when 4
        element.should be_a(Aef::Hosts::Comment)
        element.comment.should == " Another comment"
        element.to_s.should ==
          "    # Another comment\n"
        element.to_s(:force_generation => true).should ==
          "# Another comment\n"
      when 5
        element.should be_a(Aef::Hosts::Comment)
        element.comment.should == " Two lines long"
        element.to_s.should    ==
          "    # Two lines long\n"
        element.to_s(:force_generation => true).should ==
          "# Two lines long\n"
      when 6
        element.should be_a(Aef::Hosts::Entry)
        element.address.should == "127.0.0.1"
        element.name.should == "localhost"
        element.aliases.to_set.should == ['otherhost', 'evenotherhost'].to_set
        element.comment.should be_nil
        element.to_s.should ==
          "\t127.0.0.1       localhost  otherhost   evenotherhost\n"
        element.to_s(:force_generation => true).should ==
          "127.0.0.1 localhost otherhost evenotherhost\n"
      when 7
        element.should be_a(Aef::Hosts::Entry)
        element.address.should == "::1"
        element.name.should == "localhost"
        element.aliases.should be_empty
        element.comment.should be_nil
        element.to_s.should ==
          "\t::1             localhost\n"
        element.to_s(:force_generation => true).should ==
          "::1 localhost\n"
      when 8
        element.should be_a(Aef::Hosts::EmptyElement)
        element.to_s.should ==
          "    \n"
        element.to_s(:force_generation => true).should ==
          "\n"
      when 9
        element.should be_a(Aef::Hosts::Entry)
        element.address.should == "127.0.0.1"
        element.name.should == "example.net"
        element.aliases.should be_empty
        element.comment.should be_nil
        element.to_s.should ==
          "127.0.0.1\t\t\t\texample.net\n"
        element.to_s(:force_generation => true).should ==
          "127.0.0.1 example.net\n"
      when 10
        element.should be_a(Aef::Hosts::EmptyElement)
        element.to_s.should ==
          "\t\n"
        element.to_s(:force_generation => true).should ==
          "\n"
      when 11
        element.should be_a(Aef::Hosts::Entry)
        element.address.should == "2620:0:2d0:200::10"
        element.name.should == "example.com"
        element.aliases.should be_empty
        element.comment.should be_nil
        element.to_s.should ==
          "2620:0:2d0:200::10 example.com\n"
        element.to_s(:force_generation => true).should ==
          "2620:0:2d0:200::10 example.com\n"
      when 12
        element.should be_a(Aef::Hosts::Entry)
        element.address.should == "192.0.32.10"
        element.name.should == "example.com"
        element.aliases.should be_empty
        element.comment.should be_nil
        element.to_s.should ==
          "192.0.32.10        example.com\n"
        element.to_s(:force_generation => true).should ==
          "192.0.32.10 example.com\n"
      when 13
        element.should be_a(Aef::Hosts::EmptyElement)
        element.to_s.should ==
          "\n"
        element.to_s(:force_generation => true).should ==
          "\n"
      when 14
        element.should be_a(Aef::Hosts::Comment)
        element.comment.should == " Last comment"
        element.to_s.should    ==
          "\t# Last comment\n"
        element.to_s(:force_generation => true).should ==
          "# Last comment\n"
      end
    end
  end
    
  it "should be able to interpret a Linux hosts file" do
    @fixture_file = fixtures_dir + 'linux_hosts'
    @file = Aef::Hosts::File.new(@fixture_file)

    @file.read

    @file.elements.each_with_index do |element, index|
      line_number = index + 1
      case line_number
      when 1
        element.should be_a(Aef::Hosts::Comment)
        element.comment.should == " A comment"
        element.to_s.should    ==
          "# A comment\n"
        element.to_s(:force_generation => true).should ==
          "# A comment\n"
      when 2
        element.should be_a(Aef::Hosts::Entry)
        element.address.should == "127.0.0.1"
        element.name.should == "myhost"
        element.aliases.to_set.should == ['localhost.localdomain', 'localhost'].to_set
        element.comment.should be_nil
        element.to_s.should == 
          "127.0.0.1\tmyhost\tlocalhost.localdomain\tlocalhost\n"
        element.to_s(:force_generation => true).should ==
          "127.0.0.1 myhost localhost.localdomain localhost\n"
      when 3
        element.should be_a(Aef::Hosts::Entry)
        element.address.should == "127.0.1.1"
        element.name.should == "myhost.mydomain.tld"
        element.aliases.to_set.should == ['myhost'].to_set
        element.comment.should be_nil
        element.to_s.should == 
          "127.0.1.1\tmyhost.mydomain.tld myhost\n"
        element.to_s(:force_generation => true).should ==
          "127.0.1.1 myhost.mydomain.tld myhost\n"
      when 4
        element.should be_a(Aef::Hosts::Comment)
        element.comment.should == " Another comment"
        element.to_s.should ==
          "    # Another comment\n"
        element.to_s(:force_generation => true).should ==
          "# Another comment\n"
      when 5
        element.should be_a(Aef::Hosts::Comment)
        element.comment.should == " Two lines long"
        element.to_s.should    ==
          "    # Two lines long\n"
        element.to_s(:force_generation => true).should ==
          "# Two lines long\n"
      when 6
        element.should be_a(Aef::Hosts::EmptyElement)
        element.to_s.should ==
          "\n"
        element.to_s(:force_generation => true).should ==
          "\n"
      when 7
        element.should be_a(Aef::Hosts::Comment)
        element.comment.should == " The following lines are desirable for IPv6 capable hosts"
        element.to_s.should    ==
          "# The following lines are desirable for IPv6 capable hosts\n"
        element.to_s(:force_generation => true).should ==
          "# The following lines are desirable for IPv6 capable hosts\n"
      when 8
        element.should be_a(Aef::Hosts::Entry)
        element.address.should == "::1"
        element.name.should == "localhost"
        element.aliases.to_set.should == ['ip6-localhost', 'ip6-loopback'].to_set
        element.comment.should be_nil
        element.to_s.should == 
          "::1     localhost ip6-localhost ip6-loopback\n"
        element.to_s(:force_generation => true).should ==
          "::1 localhost ip6-localhost ip6-loopback\n"
      when 9
        element.should be_a(Aef::Hosts::Entry)
        element.address.should == "fe00::0"
        element.name.should == "ip6-localnet"
        element.aliases.should be_empty
        element.comment.should be_nil
        element.to_s.should == 
          "fe00::0 ip6-localnet\n"
        element.to_s(:force_generation => true).should ==
          "fe00::0 ip6-localnet\n"
      when 10
        element.should be_a(Aef::Hosts::Entry)
        element.address.should == "ff00::0"
        element.name.should == "ip6-mcastprefix"
        element.aliases.should be_empty
        element.comment.should be_nil
        element.to_s.should == 
          "ff00::0 ip6-mcastprefix\n"
        element.to_s(:force_generation => true).should ==
          "ff00::0 ip6-mcastprefix\n"
      when 11
        element.should be_a(Aef::Hosts::Entry)
        element.address.should == "ff02::1"
        element.name.should == "ip6-allnodes"
        element.aliases.should be_empty
        element.comment.should be_nil
        element.to_s.should == 
          "ff02::1 ip6-allnodes\n"
        element.to_s(:force_generation => true).should ==
          "ff02::1 ip6-allnodes\n"
      when 12
        element.should be_a(Aef::Hosts::Entry)
        element.address.should == "ff02::2"
        element.name.should == "ip6-allrouters"
        element.aliases.should be_empty
        element.comment.should be_nil
        element.to_s.should == 
          "ff02::2 ip6-allrouters\n"
        element.to_s(:force_generation => true).should ==
          "ff02::2 ip6-allrouters\n"
      when 13
        element.should be_a(Aef::Hosts::Entry)
        element.address.should == "ff02::3"
        element.name.should == "ip6-allhosts"
        element.aliases.should be_empty
        element.comment.should be_nil
        element.to_s.should == 
          "ff02::3 ip6-allhosts\n"
        element.to_s(:force_generation => true).should ==
          "ff02::3 ip6-allhosts\n"
      when 14
        element.should be_a(Aef::Hosts::EmptyElement)
        element.to_s.should ==
          "    \n"
        element.to_s(:force_generation => true).should ==
          "\n"
      when 15
        element.should be_a(Aef::Hosts::Entry)
        element.address.should == "127.0.0.1"
        element.name.should == "example.net"
        element.aliases.should be_empty
        element.comment.should be_nil
        element.to_s.should ==
          "127.0.0.1\t\t\t\texample.net\n"
        element.to_s(:force_generation => true).should ==
          "127.0.0.1 example.net\n"
      when 16
        element.should be_a(Aef::Hosts::EmptyElement)
        element.to_s.should ==
          "\t\n"
        element.to_s(:force_generation => true).should ==
          "\n"
      when 17
        element.should be_a(Aef::Hosts::Entry)
        element.address.should == "2620:0:2d0:200::10"
        element.name.should == "example.com"
        element.aliases.should be_empty
        element.comment.should be_nil
        element.to_s.should ==
          "2620:0:2d0:200::10 example.com\n"
        element.to_s(:force_generation => true).should ==
          "2620:0:2d0:200::10 example.com\n"
      when 18
        element.should be_a(Aef::Hosts::Entry)
        element.address.should == "192.0.32.10"
        element.name.should == "example.com"
        element.aliases.should be_empty
        element.comment.should be_nil
        element.to_s.should ==
          "192.0.32.10        example.com\n"
        element.to_s(:force_generation => true).should ==
          "192.0.32.10 example.com\n"
      when 19
        element.should be_a(Aef::Hosts::EmptyElement)
        element.to_s.should ==
          "\n"
        element.to_s(:force_generation => true).should ==
          "\n"
      when 20
        element.should be_a(Aef::Hosts::Comment)
        element.comment.should == " Last comment"
        element.to_s.should    ==
          "\t# Last comment\n"
        element.to_s(:force_generation => true).should ==
          "# Last comment\n"
      end
    end
  end
  
  it "should be able to append a new entry" do
    @fixture_file = fixtures_dir + 'linux_hosts'
    @file = Aef::Hosts::File.new(@fixture_file)

    @file.read
    
    @file.elements << Aef::Hosts::Entry.new(
      '192.168.23.5', 'the-new-host', :aliases => [
        'the-new-host.domain.tld',
        'service.domain.tld'
      ]
    )
    
    lines = @file.to_s.lines.to_a
    lines[21].should == "192.168.23.5 the-new-host the-new-host.domain.tld service.domain.tld\n"
  end
  
  it "should be able to insert a new entry" do
    @fixture_file = fixtures_dir + 'linux_hosts'
    @file = Aef::Hosts::File.new(@fixture_file)

    @file.read
    
    @file.elements.insert(9, Aef::Hosts::Entry.new(
      '192.168.23.5', 'the-new-host', :aliases => [
        'the-new-host.domain.tld',
        'service.domain.tld'
      ]
    ))
    
    lines = @file.to_s.lines.to_a
    lines[9].should == "192.168.23.5 the-new-host the-new-host.domain.tld service.domain.tld\n" 
  end
  
  it "should be able to prepend a new entry" do
    @fixture_file = fixtures_dir + 'linux_hosts'
    @file = Aef::Hosts::File.new(@fixture_file)

    @file.read
    
    @file.elements.unshift(Aef::Hosts::Entry.new(
      '192.168.23.5', 'the-new-host', :aliases => [
        'the-new-host.domain.tld',
        'service.domain.tld'
      ]
    ))
    
    lines = @file.to_s.lines.to_a
    lines[0].should == "192.168.23.5 the-new-host the-new-host.domain.tld service.domain.tld\n"
  end
end
