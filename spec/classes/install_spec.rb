require 'spec_helper'

describe 'sssd' do
  context 'supported operating systems' do
    on_supported_os.each do |os, facts|
      context "on #{os}" do
        let(:facts) do
          facts
        end

        context "sssd::install class with default parameters on #{os}" do
          let(:params) {{ }}

          describe 'sssd::install class' do
            it { should contain_package('sssd').with_ensure('present') }
	        end

          case facts[:osfamily]
          when 'Debian'
            it { should contain_package('libpam-runtime').with_ensure('present') }
            it { should contain_package('libpam-sss').with_ensure('present') }
            it { should contain_package('libnss-sss').with_ensure('present') }
          when 'RedHat'
            if facts[:operatingsystemmajrelease] =~ /(6|7)/
              it { should contain_package('authconfig').with_ensure('present') }
            else
              it { should contain_package('authconfig').with_ensure('latest') }
            end
          end
        end

        context "sssd::install class with custom parameters on #{os}" do
          let(:params) do
            {
	            :config => {
	              'domain/AD'   => { 'ldap_force_upper_case_realm' => false, },
	              'domain/LDAP' => { 'cache_credentials' => false, },
	              'sssd'        => { 'domains' => ['AD','LDAP'], },
              },
	            :mkhomedir           => true,
	          }
          end
          
        end
      end
    end
  end
end
