require 'spec_helper_acceptance'

test_name 'ptpd test'

describe 'ptpd test' do
  servers = hosts_with_role(hosts, 'server')
  servers.each do |server|
    let(:manifest) {
      <<-EOS
      class {'ptpd':}
      EOS
    }

    let(:manifest_with_rule) {
      <<-EOS
      class { 'ptpd': ptp_master => false }
      EOS
    }

    context 'default parameters(server)' do
      it 'should work with no errors' do
        apply_manifest_on(servers, manifest, :catch_failures => true)
      end
      it 'should be idempotent' do
        apply_manifest_on(servers, manifest, :catch_changes => true)
      end

      describe package('ptpd') do
        it { is_expected.to be_installed }
      end

      describe service('ptpd') do
        it { is_expected.to be_running }
        it { is_expected.to be_enabled }
      end

      describe port(319) do
        it { should be_listening }
      end

      describe port(320) do
        it { should be_listening }
      end
    end
    context 'changed parameters(client)' do
      it 'should work with no errors' do
        apply_manifest_on(servers, manifest_with_rule, :catch_failures => true)
      end
      it 'should be idempotent' do
        apply_manifest_on(servers, manifest_with_rule, :catch_changes => true)
      end

      describe package('ptpd') do
        it { is_expected.to be_installed }
      end

      describe service('ptpd') do
        it {is_expected.to be_running }
        it {is_expected.to be_enabled }
      end

      describe port(319) do
        it { should be_listening }
      end
      describe port(320) do
        it { should be_listening }
      end
    end
  end
end




