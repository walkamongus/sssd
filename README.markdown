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

##Setup

###What sssd affects

* Packages
    * sssd
* Files
    * sssd.conf
* Services
    * sssd daemon

###Beginning with sssd

Install SSSD with default config file:

     class {'::sssd': }

##Usage

Install SSSD with custom configuration:

    class {'::sssd:
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

* Classes

    sssd::params
    sssd::init
    sssd::install
    sssd::config
    sssd::service

##Limitations

This is where you list OS compatibility, version compatibility, etc.
