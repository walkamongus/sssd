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

          it { should compile.with_all_deps }
          it { should contain_class('sssd::install').that_comes_before('Class[sssd::config]') }
          it { should contain_class('sssd::config') }
          it { should contain_class('sssd::service').that_subscribes_to('Class[sssd::config]') }
        end
      end
    end
  end

  context 'unsupported operating system' do
    describe 'sssd class without any parameters on Solaris/Nexenta' do
      let(:facts) {{:osfamily => 'Solaris', :operatingsystem => 'Nexenta',}}
      it { expect { should contain_package('sssd') }.to raise_error(Puppet::Error) }
    end
  end
end
