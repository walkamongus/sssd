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

          describe 'sssd::install class' do
            it { should contain_package('sssd').with_ensure('present') }
            it { should contain_package('authconfig').with_ensure('present') }
            it { should contain_package('libsss_idmap').with_ensure('present') }
	        end
        end

        context "sssd class with some custom parameters on #{os}" do
          let(:params) do
            {
	            :config => {
	              'domain/AD'   => { 'ldap_force_upper_case_realm' => false, },
	              'domain/LDAP' => { 'cache_credentials' => false, },
	              'sssd'        => { 'domains' => ['AD','LDAP'], },
              },
	            :mkhomedir           => 'enabled',
	            :use_legacy_packages => true,
	            :manage_idmap        => false,
	            :manage_authconfig   => false,
	          }
          end
          
	        describe 'sssd::install class' do
            it { should contain_package('libsss_sudo').with_ensure('present') }
            it { should contain_package('libsss_autofs').with_ensure('present') }
            it { should_not contain_package('authconfig') }
            it { should_not contain_package('libsss_idmap') }
	        end
        end
      end
    end
  end
end
