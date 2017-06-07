require 'spec_helper'

describe 'sssd' do
  context 'supported operating systems' do
    on_supported_os.each do |os, facts|
      context "on #{os}" do
        let(:facts) do
          facts
        end

        context "sssd class without any parameters on #{os}" do
          let(:params) {{ }}

          case facts[:osfamily]
          when 'RedHat'
            describe 'sssd::config class' do
              it do
                should contain_file('sssd_config_file').with({
                   :path  => '/etc/sssd/sssd.conf',
                   :owner => 'root',
                   :group => 'root',
                   :mode  => '0600'
                 })
              end

              it { should contain_file('sssd_config_file').with_content(/services = nss,pam/) }

              it do
                should contain_exec('enable_mkhomedir').with({
                   :command => '/usr/sbin/authconfig --enablemkhomedir --update',
                   :unless  => "/bin/grep -E '^USEMKHOMEDIR=yes$' /etc/sysconfig/authconfig"
                 })
              end
            end
          when 'Debian'
            it do
              should contain_file('sssd_config_file').with({
                :path  => '/etc/sssd/sssd.conf',
                :owner => 'root',
                :group => 'root',
                :mode  => '0600'
              })
            end

            it { should contain_file('sssd_config_file').with_content(/services = nss,pam/) }

            it do
              should contain_exec('enable_mkhomedir').with({
                :command => '/usr/sbin/pam-auth-update',
                :unless  => "/bin/grep -E 'pam_mkhomedir.so' /etc/pam.d/common-session"
              })
            end
            it do
              should contain_file('/usr/share/pam-configs/mkhomedir').with({
                'ensure' => 'file',
                'source' => 'puppet:///modules/sssd/mkhomedir',
                'before' => 'Exec[enable_mkhomedir]',
              })
            end
          end
        end

        describe "sssd class with some custom parameters on #{os}" do
          let(:params) do
            {
               :config    => {
                 'domain/AD'   => { 'ldap_force_upper_case_realm' => false, },
                 'domain/LDAP' => { 'cache_credentials' => false, },
                 'sssd'        => { 'domains' => ['AD','LDAP'], },
              },
               :mkhomedir => false,
             }
          end

          case facts[:osfamily]
          when 'RedHat'
            describe 'sssd::config class' do
              it { should contain_file('sssd_config_file').with_content(/domains = AD,LDAP/) }
              it { should contain_file('sssd_config_file').with_content(/cache_credentials = false/) }
              it { should contain_file('sssd_config_file').with_content(/ldap_force_upper_case_realm = false/) }

              it do
                should contain_exec('disable_mkhomedir').with({
                  :command => '/usr/sbin/authconfig --disablemkhomedir --update',
                  :onlyif  => '/bin/grep -E \'^USEMKHOMEDIR=yes$\' /etc/sysconfig/authconfig'
                })
              end
            end
          when 'Debian'
            describe 'sssd::config class' do
              it { should contain_file('sssd_config_file').with_content(/domains = AD,LDAP/) }
              it { should contain_file('sssd_config_file').with_content(/cache_credentials = false/) }
              it { should contain_file('sssd_config_file').with_content(/ldap_force_upper_case_realm = false/) }

              it do
                should contain_exec('disable_mkhomedir').with({
                   :command => '/usr/sbin/pam-auth-update',
                   :onlyif  => '/bin/grep -E \'pam_mkhomedir.so\' /etc/pam.d/common-session'
                 })
              end
            end
          end
        end
      end
    end
  end
end
