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
    * authconfig
    * oddjob-mkhomedir
    * libpam-runtime
    * libpam-sss
    * libnss-sss
* Files
    * sssd.conf
* Services
    * sssd daemon
* Execs
    * the authconfig or pam-auth-update commands are run to enable/disable SSSD functionality.

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
        },
        'domain/MY_DOMAIN' => {
          'key' => 'value',
        },
        'pam' => {
          'key' => 'value',
        },
      }
    }


##Reference

###Parameters

* `package_name`: String. Name of the SSSD package to install.
* `package_ensure`: String. Ensure value to set for the SSSD package.
* `service_name`: String. Name of the SSSD service to manage.
* `service_ensure`:  Variant[Enum['running','stopped'], Boolean]. Ensure value to set for the SSSD service.
* `config_file`: Stdlib::Absolutepath. Path to the `SSSD` config file.
* `config`: Hash. A hash of configuration options structured like the sssd.conf file. Array values will be joined into comma-separated lists. 
* `mkhomedir`: Boolean. Enables auto-creation of home directories on user login.
* `pam_mkhomedir_method`: Enum['pam-auth-update', 'authconfig']. Set supported method for controlling SSSD configuration.
* `pam_mkhomedir_file_path`: Variant[Stdlib::Absolutepath, Undef]. Path to the PAM mkhomedir config file. Only used when `pam_mkhomedir_method => pam-auth-update`.
* `cache_path`: Stdlib::Absolutepath. Path to the SSSD cache files.
* `clear_cache`: Boolean. Enables clearing of the SSSD cache on configuration updates.
* `required_packages`: Hash. A Hash of package resources to additionally install with the core SSSD packages

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

* sssd::init
* sssd::install
* sssd::config
* sssd::service

