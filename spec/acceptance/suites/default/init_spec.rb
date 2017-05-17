require 'spec_helper_acceptance'

test_name 'ptpd test'

describe 'ptpd el7 test' do
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

    context 'normal parameters(el7)' do

      it 'should work with no errors' do
        apply_manifest_on(server, manifest, :catch_failures => true)
      end

      it 'should be idempotent' do
        apply_manifest_on(server, manifest, :catch_changes => true)
      end

      it 'should be installed' do
        result = on(server, "rpm -q ptpd")
        expect(result.exit_code).to be(0)
      end 

      it 'should be running' do
        result = on(server, '/bin/sh -c "service ptpd2 status | grep active"')
        expect(result.stdout).to include("Active: active (running)")
      end

      it 'should be enabled' do
        result = on(server, '/bin/sh -c "service ptpd2 status | grep loaded"')
        expect(result.stdout).to include("enabled")
      end

      it 'should be listening on ports 319 and 320' do
        result = on(server, "netstat -plnu")
        expect(result.stdout).to include("319", "320")
      end

      it 'should be a master' do
        result = on(server, "cat /etc/ptpd2.conf | grep ptpengine:preset")
        expect(result.stdout).to include("ptpengine:preset=masteronly")
      end
    end

    context 'changed parameters(el7)' do

      it 'should work with no errors' do
        apply_manifest_on(server, manifest_with_rule, :catch_failures => true)
      end

      it 'should be idempotent' do
        apply_manifest_on(server, manifest_with_rule, :catch_changes => true)
      end

      it 'should be installed' do
        result = on(server, "rpm -q ptpd")
        expect(result.exit_code).to be(0)  
      end

      it 'should be running' do
        result = on(server, '/bin/sh -c "service ptpd2 status | grep active"')
        expect(result.stdout).to include("Active: active (running)") 
      end

      it 'should be enabled' do
        result = on(server, '/bin/sh -c "service ptpd2 status | grep loaded"')
        expect(result.stdout).to include("enabled")
      end

      it 'should be listening on ports 319 and 320' do
        result = on(server, "netstat -plnu")
        expect(result.stdout).to include("319","320")
      end

      it 'should be a server' do
        result = on(server, "cat /etc/ptpd2.conf | grep ptpengine:preset")
        expect(result.stdout).to include("ptpengine:preset=serveronly")
      end
    end
  end
end


describe 'ptpd el6 test' do
  servers = hosts_with_role(hosts, 'server2')
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

    context 'normal parameters(el6)' do

      it 'should work with no errors' do
        apply_manifest_on(server, manifest, :catch_failures => true)
      end

      it 'should be idempotent' do
        apply_manifest_on(server, manifest, :catch_changes => true)
      end

      it 'should be installed' do
        result = on(server, "rpm -q ptpd")
        expect(result.exit_code).to be(0)
      end 

      it 'should be running' do
        result = on(server, "service ptpd2 status | grep running")
        expect(result.stdout).to include("running")
      end

      it 'should be enabled' do
        result = on(server, "chkconfig --list ptpd2")
        expect(result.stdout).to include("3:on")
      end

      it 'should be listening on ports 319 and 320' do
        result = on(server, "netstat -plnu")
        expect(result.stdout).to include("319", "320")
      end

      it 'should be a master' do
        result = on(server, "cat /etc/ptpd2.conf | grep ptpengine:preset")
        expect(result.stdout).to include("ptpengine:preset=masteronly")
      end
    end

    context 'changed parameters(el6)' do

      it 'should work with no errors' do
        apply_manifest_on(server, manifest_with_rule, :catch_failures => true)
      end

      it 'should be idempotent' do
        apply_manifest_on(server, manifest_with_rule, :catch_changes => true)
      end

      it 'should be installed' do
        result = on(server, "rpm -q ptpd")
        expect(result.exit_code).to be(0)  
      end

      it 'should be running' do
        result = on(server, "service ptpd2 status | grep running")
        expect(result.stdout).to include("running") 
      end

      it 'should be enabled' do
        result = on(server, "chkconfig --list ptpd2")
        expect(result.stdout).to include("3:on")
      end

      it 'should be listening on ports 319 and 320' do
        result = on(server, "netstat -plnu")
        expect(result.stdout).to include("319","320")
      end

      it 'should be a server' do
        result = on(server, "cat /etc/ptpd2.conf | grep ptpengine:preset")
        expect(result.stdout).to include("ptpengine:preset=serveronly")
      end
    end
  end
end






