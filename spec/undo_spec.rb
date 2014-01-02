require 'spec_helper'

describe 'yum-dell::undo' do
  context 'on Centos 6.4' do
    let(:chef_run) do
      ChefSpec::Runner.new(platform: 'centos', version: 6.4, step_into: ['yum_repository']).converge(described_recipe)
    end

    it 'deletes yum repository dell-community' do
      expect(chef_run).to delete_yum_repository('dell-community')
    end

    it 'deletes yum repository dell-omsa-indep' do
      expect(chef_run).to delete_yum_repository('dell-omsa-indep')
    end

    it 'deletes yum repository dell-omsa-specific' do
      expect(chef_run).to delete_yum_repository('dell-omsa-specific')
    end

    it 'recursively deletes /opt/dell/srvadmin' do
      expect(chef_run).to delete_directory('/opt/dell/srvadmin').with(
        recursive: true
      )
    end
  end
end
