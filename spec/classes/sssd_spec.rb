require 'spec_helper'

describe 'sssd' do
  context 'supported operating systems' do
    ['RedHat'].each do |osfamily|
      describe "sssd class without any parameters on #{osfamily}" do
        let(:params) {{ }}
        let(:facts) {{
          :osfamily => osfamily,
        }}

        it { should compile.with_all_deps }

        it { should contain_class('sssd::params') }
        it { should contain_class('sssd::install').that_comes_before('sssd::config') }
        it { should contain_class('sssd::config') }
        it { should contain_class('sssd::service').that_subscribes_to('sssd::config') }

        it { should contain_service('sssd') }
        it { should contain_package('sssd').with_ensure('present') }
      end
    end
  end

  context 'unsupported operating system' do
    describe 'sssd class without any parameters on Solaris/Nexenta' do
      let(:facts) {{
        :osfamily        => 'Solaris',
        :operatingsystem => 'Nexenta',
      }}

      it { expect { should contain_package('sssd') }.to raise_error(Puppet::Error, /Nexenta not supported/) }
    end
  end
end
