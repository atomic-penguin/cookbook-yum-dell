require 'spec_helper'

describe 'yum-dell::default' do
  context 'on Centos 6.4 with Dell hardware' do
    let(:chef_run) do
      ChefSpec::Runner.new(platform: 'centos', version: 6.4, step_into: ['yum_repository']) do |node|
        node.automatic['dmi']['system']['manufacturer'] = 'Dell Inc.'
      end.converge(described_recipe)
    end

    it 'installs dmidecode' do
      expect(chef_run).to install_package('dmidecode')
    end

    it 'download file RPM-GPG-KEY-dell-community' do
      expect(chef_run).to create_remote_file('/etc/pki/rpm-gpg/RPM-GPG-KEY-dell-community')
    end

    it 'imports RPM-GPG-KEY-dell-community' do
      expect(chef_run).to run_execute('rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-dell-community')
    end

    it 'download file RPM-GPG-KEY-dell-omsa-indep' do
      expect(chef_run).to create_remote_file('/etc/pki/rpm-gpg/RPM-GPG-KEY-dell-omsa-indep')
    end

    it 'imports RPM-GPG-KEY-dell-omsa-indep' do
      expect(chef_run).to run_execute('rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-dell-omsa-indep')
    end

    it 'download file RPM-GPG-KEY-dell-omsa-specific' do
      expect(chef_run).to create_remote_file('/etc/pki/rpm-gpg/RPM-GPG-KEY-dell-omsa-specific')
    end

    it 'imports RPM-GPG-KEY-dell-omsa-indep' do
      expect(chef_run).to run_execute('rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-dell-omsa-specific')
    end

    it 'creates yum repository dell-community' do
      expect(chef_run).to create_yum_repository('dell-community')
    end

    it 'renders /etc/yum.repos.d/dell-community.repo with correct mirrorlist' do
      expect(chef_run).to render_file('/etc/yum.repos.d/dell-community.repo').with_content(
        'mirrorlist=http://linux.dell.com/repo/community/mirrors.cgi?osname=el6&basearch=$basearch'
      )
    end

    it 'creates yum repository dell-omsa-indep' do
      expect(chef_run).to create_yum_repository('dell-omsa-indep')
    end

    it 'renders /etc/yum.repos.d/dell-omsa-indep.repo with correct mirrorlist' do
      expect(chef_run).to render_file('/etc/yum.repos.d/dell-omsa-indep.repo').with_content(
        'mirrorlist=http://linux.dell.com/repo/hardware/latest/mirrors.cgi?' +
        'osname=el6&basearch=$basearch&native=1&dellsysidpluginver=$dellsysidpluginver'
      )
    end

    it 'creates yum repository dell-omsa-specific' do
      expect(chef_run).to create_yum_repository('dell-omsa-specific')
    end

    it 'renders /etc/yum.repos.d/dell/omsa-specific.repo with correct mirrorlist' do
      expect(chef_run).to render_file('/etc/yum.repos.d/dell-omsa-specific.repo').with_content(
        'mirrorlist=http://linux.dell.com/repo/hardware/latest/mirrors.cgi' +
        '?osname=el6&basearch=$basearch&native=1&sys_ven_id=$sys_ven_id&sys_dev_id=$sys_dev_id&dellsysidpluginver=$dellsysidpluginver'
      )
    end

    it 'installs srvadmin-all' do
      expect(chef_run).to install_package('srvadmin-all')
    end
  end

  context 'on Centos 6.4 on non-Dell hardware' do
    let(:chef_run) do
      ChefSpec::Runner.new(platform: 'centos', version: 6.4, step_into: ['yum_repository']) do |node|
        node.automatic['dmi']['system']['manufacturer'] = 'VMWare Inc.'
      end.converge(described_recipe)
    end

    it 'download file RPM-GPG-KEY-dell-community' do
      expect(chef_run).to create_remote_file('/etc/pki/rpm-gpg/RPM-GPG-KEY-dell-community')
    end

    it 'imports RPM-GPG-KEY-dell-community' do
      expect(chef_run).to run_execute('rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-dell-community')
    end

    it 'to not download file RPM-GPG-KEY-dell-omsa-indep' do
      expect(chef_run).to_not create_remote_file('/etc/pki/rpm-gpg/RPM-GPG-KEY-dell-omsa-indep')
    end

    it 'to not import RPM-GPG-KEY-dell-omsa-indep' do
      expect(chef_run).to_not run_execute('rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-dell-omsa-indep')
    end

    it 'to not download file RPM-GPG-KEY-dell-omsa-specific' do
      expect(chef_run).to_not create_remote_file('/etc/pki/rpm-gpg/RPM-GPG-KEY-dell-omsa-specific')
    end

    it 'to not import RPM-GPG-KEY-dell-omsa-indep' do
      expect(chef_run).to_not run_execute('rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-dell-omsa-specific')
    end

    it 'to not create yum repository dell-community' do
      expect(chef_run).to create_yum_repository('dell-community')
    end

    it 'renders dell-community.repo with correct mirrorlist' do
      expect(chef_run).to render_file('/etc/yum.repos.d/dell-community.repo').with_content(
        'mirrorlist=http://linux.dell.com/repo/community/mirrors.cgi?osname=el6&basearch=$basearch'
      )
    end

    it 'to not create yum repository dell-omsa-indep' do
      expect(chef_run).to_not create_yum_repository('dell-omsa-indep')
    end

    it 'to not create yum repository dell-omsa-specific' do
      expect(chef_run).to_not create_yum_repository('dell-omsa-specific')
    end

    it 'to not install srvadmin-all' do
      expect(chef_run).to_not install_package('srvadmin-all')
    end
  end
end
