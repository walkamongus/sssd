require 'spec_helper'

describe 'sssd' do
  context 'supported operating systems' do
    on_supported_os.each do |os, facts|
      context "on #{os}" do
        let(:facts) do
          facts
        end

        context "sssd::config class with default parameters on #{os}" do
          let(:params) {{ }}

          it do
            should contain_file('sssd_config_file').with({
               :path  => '/etc/sssd/sssd.conf',
               :owner => 'root',
               :group => 'root',
               :mode  => '0600'
             })
          end

          it { should contain_file('sssd_config_file').with_content(/services = nss,pam/) }

          case facts[:osfamily]
          when 'RedHat'
            args = '--enablemkhomedir --enablesssd --enablesssdauth'
            it do
              should contain_exec('authconfig_update').with({
                 :command => "authconfig #{args} --update",
                 :path    => ['/sbin', '/bin', '/usr/sbin', '/usr/bin'],
                 :unless  => "/usr/bin/test \"$(authconfig #{args} --test)\" = \"$(authconfig --test)\""
               })
            end
          when 'Debian'
            it do
              should contain_file('/usr/share/pam-configs/mkhomedir').with({
                'ensure' => 'file',
                'source' => 'puppet:///modules/sssd/mkhomedir',
                'notify' => 'Exec[update_mkhomedir]',
              })
            end

            it do
              should contain_exec('update_mkhomedir').with({
                :command      => '/usr/sbin/pam-auth-update',
                :refreshonly  => true,
              })
            end
          end
        end

        describe "sssd class with some custom parameters on #{os}" do
          let(:params) do
            {
               :config      => {
                 'domain/AD'   => { 'ldap_force_upper_case_realm' => false, },
                 'domain/LDAP' => { 'cache_credentials' => false, },
                 'sssd'        => { 'domains' => ['AD','LDAP'], },
              },
               :mkhomedir   => false,
               :clear_cache => true,
             }
          end

          it { should contain_file('sssd_config_file').that_notifies('Exec[clear_cache]') }
          it { should contain_exec('clear_cache').that_notifies('Service[sssd]') }
          it { should contain_file('sssd_config_file').with_content(/domains = AD,LDAP/) }
          it { should contain_file('sssd_config_file').with_content(/cache_credentials = false/) }
          it { should contain_file('sssd_config_file').with_content(/ldap_force_upper_case_realm = false/) }

          case facts[:osfamily]
          when 'RedHat'
            args = '--disablemkhomedir --disablesssd --disablesssdauth'
            it do
              should contain_exec('authconfig_update').with({
                 :command => "authconfig #{args} --update",
                 :path    => ['/sbin', '/bin', '/usr/sbin', '/usr/bin'],
                 :unless  => "/usr/bin/test \"$(authconfig #{args} --test)\" = \"$(authconfig --test)\""
               })
            end
          when 'Debian'
            it do
              should contain_file('/usr/share/pam-configs/mkhomedir').with({
                'ensure' => 'absent',
                'source' => 'puppet:///modules/sssd/mkhomedir',
                'notify' => 'Exec[update_mkhomedir]',
              })
            end

            it do
              should contain_exec('update_mkhomedir').with({
                :command      => '/usr/sbin/pam-auth-update',
                :refreshonly  => true,
              })
            end
          end
        end
      end
    end
  end
end
