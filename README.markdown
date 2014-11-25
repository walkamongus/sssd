# sssd Puppet Module

[![Build Status](https://travis-ci.org/walkamongus/sssd.svg)](https://travis-ci.org/walkamongus/sssd)

####Table of Contents

1. [Overview](#overview)
2. [Module Description - What the module does and why it is useful](#module-description)
3. [Setup - The basics of getting started with sssd](#setup)
    * [What sssd affects](#what-sssd-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with sssd](#beginning-with-sssd)
4. [Usage - Configuration options and additional functionality](#usage)
5. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
5. [Limitations - OS compatibility, etc.](#limitations)

##Overview

This module installs (if necessary) and configures the System Security Services Daemon. 

##Module Description

The System Security Services Daemon bridges the gap between local authentication requests 
and remote authentication providers.  This module installs the required sssd packages and 
builds the sssd.conf configuration file. It will also enable the sssd service and ensure 
it is running. 

Auto-creation of user home directories on first login via the PAM mkhomedir.so module may 
be enabled or disabled (defaults to disabled).

For SSH and Sudo integration with SSSD, this module works well with [saz/ssh](https://forge.puppetlabs.com/saz/ssh) and [trlinkin/nsswitch](https://forge.puppetlabs.com/trlinkin/nsswitch).

##Setup

###What sssd affects

* Packages
    * sssd
    * libsss_idmap
    * authconfig
    * libsss_sudo (legacy)
    * libsss_autofs (legacy)
* Files
    * sssd.conf
* Services
    * sssd daemon
* Execs
    * the authconfig command is run to enable or disable the PAM mkhomedir.so functionality

###Beginning with sssd

Install SSSD with a bare default config file:

     class {'::sssd': }

##Usage

Install SSSD with custom configuration:

    class {'::sssd':
      config => {
        'sssd' => {
          'key'     => 'value',
          'domains' => ['MY_DOMAIN', 'LDAP',],
        }
        'domain/MY_DOMAIN' => {
          'key' => 'value',
        }
        'pam' => {
          'key' => 'value',
        }
      }
    }


##Reference

###Parameters

* `mkhomedir`: Defaults to 'disabled'.  Set to 'enabled' to enable auto-creation of home directories on user login
* `use_legacy_packages`: Boolean. Defaults to false.  Set to true to install the legacy 'libsss_sudo
                         and 'libsss_autofs' packages. These packages were absorbed into the
                         'sssd-common' package.
* `config`: A hash of configuration options stuctured like the sssd.conf file. Array values will be joined into comma-separated lists. 
* `manage_idmap`: Boolean. Defaults to true. Set to false to disable management of the idmap package
* `manage_authconfig`: Boolean. Defaults to true. Set to false to disable management of the authconfig package

For example:

    class {'::sssd':
      config => {
        'sssd' => {
          'key1' => 'value1',
          'keyX' => [ 'valueY', 'valueZ' ],
        },
        'domain/LDAP' => {
          'key2' => 'value2',
        },
      }

or in hiera:

    sssd::config:
      'sssd':
        key1: value1
        keyX:
          - valueY
          - valueZ
      'domain/LDAP':
        key2: value2

Will be represented in sssd.conf like this:

    [sssd]
    key1 = value1
    keyX = valueY, valueZ

    [domain/LDAP]
    key2 = value2

###Classes

* sssd::params
* sssd::init
* sssd::install
* sssd::config
* sssd::service

##Limitations

Developed using:
* Puppet 3.6.2
* CentOS 6.5
