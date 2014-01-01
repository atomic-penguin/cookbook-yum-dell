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

    it 'renders /etc/yum.repos.d/dell-community.repo with correct mirrorlist' do
      expect(chef_run).to render_file('/etc/yum.repos.d/dell-community.repo').with_content(
        'mirrorlist=http://linux.dell.com/repo/community/mirrors.cgi?osname=el6&basearch=$basearch'
      )
    end

    it 'renders /etc/yum.repos.d/dell-omsa-indep.repo with correct mirrorlist' do
      expect(chef_run).to render_file('/etc/yum.repos.d/dell-omsa-indep.repo').with_content(
        'mirrorlist=http://linux.dell.com/repo/hardware/latest/mirrors.cgi?' +
        'osname=el6&basearch=$basearch&native=1&dellsysidpluginver=$dellsysidpluginver'
      )
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

    it 'renders /etc/yum.repos.d/dell-community.repo with correct mirrorlist' do
      expect(chef_run).to render_file('/etc/yum.repos.d/dell-community.repo').with_content(
        'mirrorlist=http://linux.dell.com/repo/community/mirrors.cgi?osname=el6&basearch=$basearch'
      )
    end

    it 'does not render /etc/yum.repos.d/dell-omsa-indep.repo' do
      expect(chef_run).not_to render_file('/etc/yum.repos.d/dell-omsa-indep.repo')
    end

    it 'does not /etc/yum.repos.d/dell/omsa-specific.repo' do
      expect(chef_run).not_to render_file('/etc/yum.repos.d/dell-omsa-specific.repo')
    end

    it 'does not install srvadmin-all' do
      expect(chef_run).not_to install_package('srvadmin-all')
    end
  end
end
