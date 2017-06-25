require 'spec_helper'

describe 'sssd' do
  context 'supported operating systems' do
    on_supported_os.each do |os, facts|
      context "on #{os}" do
        let(:facts) do
          facts
        end

        context "sssd::service class with default parameters on #{os}" do
          let(:params) {{ }}

	        describe 'sssd::service class' do
            it { should contain_service('sssd').with_ensure('running') }
	        end
        end
      end
    end
  end
end
