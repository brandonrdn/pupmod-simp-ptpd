require 'spec_helper_acceptance'

test_name 'ptpd_test'

describe 'ptpd' do
  let(:server){ hosts_with_role(hosts, 'server')}
  let(:ptpd) {
    <<-EOS
      class {'ptpd':}
    EOS
  }

  let(:ptpd_with_rule) {
    <<-EOS
      class { 'ptpd': ptp_master => false }
    EOS
  }

  context 'default parameters(server)' do
    it 'should work with no errors' do
      apply_manifest_on(server, ptpd, :catch_failures => true)
    end
    it 'should be idempotent' do
      apply_manifest_on(server, ptpd, :catch_changes => true)
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
      apply_manifest_on(server, ptpd_with_rule, :catch_failures => true)
    end
    it 'should be idempotent' do
      apply_manifest_on(server, ptpd_with_rule, :catch_changes => true)
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

# describe 'ptpd' do
#  servers = hosts_with_role(hosts, 'server')
#  servers.each do |server|

#     context 'default parameters' do
#       let (:manifest) {
#         <<-EOS
#       include ptpd
#         EOS
#       }
#       it 'should apply without errors' do
#         # Run it twice and test for idempotency
#         apply_manifest(manifest, :catch_failures => true)
#         expect(apply_manifest(manifest, :catch_failures => true).exit_code).to be_z    ero



# class ptpd(

#   String $ptpinterface = 'eth0',
#   Boolean $ptp_master = true,
# ){

#   package { 'ptpd':
#     ensure => 'installed',
#   }

#   if ($ptp_master) {
#     $ptpengine = 'masteronly'
#   } else {
#     $ptpengine = 'serveronly'
#   }

#   service { 'ptpd':
#     ensure     => 'running',
#     enable     => true,
#     hasstatus  => true,
#     hasrestart => true,
#     require    => Package['ptpd'],
#   }

#   file { '/etc/ptpd2.conf':
#     ensure  => 'file',
#     owner   => 'root',
#     group   => 'root',
#     mode    => '0644',
#     content => template('ptpd/ptpd.conf.erb'),
#   }
# }


