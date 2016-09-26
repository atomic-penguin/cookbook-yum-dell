require 'spec_helper'

describe 'yum-dell::default' do
  context 'on Centos 6.4 x86_64 with Dell hardware' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new(platform: 'centos', version: 6.4, step_into: ['yum_repository']) do |node|
        node.automatic['dmi']['system']['manufacturer'] = 'Dell Inc.'
        node.automatic['kernel']['machine'] = 'x86_64'
      end.converge(described_recipe)
    end

    it 'installs dmidecode' do
      expect(chef_run).to install_package('dmidecode')
    end

    it 'creates dell-community repository with correct mirrorlist' do
      expect(chef_run).to create_yum_repository('dell-community').with(
        mirrorlist: 'http://linux.dell.com/repo/community/mirrors.cgi?osname=el6&basearch=$basearch'
      )
    end

    it 'creates dell-omsa-indep repository with correct mirrorlist' do
      expect(chef_run).to create_yum_repository('dell-omsa-indep').with(
        mirrorlist: 'http://linux.dell.com/repo/hardware/latest/mirrors.cgi?osname=el6&basearch=$basearch&native=1&dellsysidpluginver=$dellsysidpluginver'
      )
    end

    it 'renders dell-omsa-specific repository with correct mirrorlist' do
      expect(chef_run).to create_yum_repository('dell-omsa-specific').with(
        mirrorlist: 'http://linux.dell.com/repo/hardware/latest/mirrors.cgi?osname=el6&basearch=$basearch&native=1&sys_ven_id=$sys_ven_id&sys_dev_id=$sys_dev_id&dellsysidpluginver=$dellsysidpluginver'
      )
    end

    it 'installs srvadmin-all' do
      expect(chef_run).to install_package('srvadmin-all')
    end
  end

  context 'on Centos 6.4 x86_64 on non-Dell hardware' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new(platform: 'centos', version: 6.4, step_into: ['yum_repository']) do |node|
        node.automatic['dmi']['system']['manufacturer'] = 'VMWare Inc.'
        node.automatic['kernel']['machine'] = 'x86_64'
      end.converge(described_recipe)
    end

    it 'creates dell-community repository with correct mirrorlist' do
      expect(chef_run).to create_yum_repository('dell-community').with(
        mirrorlist: 'http://linux.dell.com/repo/community/mirrors.cgi?osname=el6&basearch=$basearch'
      )
    end

    it 'to not create dell-omsa-indep repository' do
      expect(chef_run).to_not create_yum_repository('dell-omsa-indep')
    end

    it 'to not create dell-omsa-specific repository' do
      expect(chef_run).to_not create_yum_repository('dell-omsa-specific')
    end

    it 'to not install srvadmin-all' do
      expect(chef_run).to_not install_package('srvadmin-all')
    end
  end

  context 'on Centos 6.4 i686 on Dell hardware' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new(platform: 'centos', version: 6.4, step_into: ['yum_repository']) do |node|
        node.automatic['dmi']['system']['manufacturer'] = 'Dell Inc.'
        node.automatic['kernel']['machine'] = 'i686'
      end.converge(described_recipe)
    end

    it 'creates dell-community repository with i386 architecture' do
      expect(chef_run).to create_yum_repository('dell-community').with(
        mirrorlist: 'http://linux.dell.com/repo/community/mirrors.cgi?osname=el6&basearch=i386',
        gpgkey: 'http://linux.dell.com/repo/community/content/el6-i386/repodata/repomd.xml.key'
      )
    end

    it 'creates dell-omsa-specific repository with i386 architecture' do
      expect(chef_run).to create_yum_repository('dell-omsa-specific').with(
        mirrorlist: 'http://linux.dell.com/repo/hardware/latest/mirrors.cgi?osname=el6&basearch=i386&native=1&sys_ven_id=$sys_ven_id&sys_dev_id=$sys_dev_id&dellsysidpluginver=$dellsysidpluginver'
      )
    end
  end
end
