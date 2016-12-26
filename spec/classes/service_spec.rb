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

	        describe 'sssd::service class' do
            it { should contain_service('sssd') }
	        end
        end
      end
    end
  end
end
