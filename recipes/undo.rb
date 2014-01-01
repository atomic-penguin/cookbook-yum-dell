#
# Cookbook Name:: yum-dell
# Recipe:: undo
#
# Copyright 2010, Eric G. Wolfe
# Copyright 2010, Tippr Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# Force uninstall of all srvadmin packages.
execute 'srvadmin-uninstall-force' do
  command '/opt/dell/srvadmin/sbin/srvadmin-uninstall.sh -f'
  action :run
  only_if { ::File.exists?('/opt/dell/srvadmin/sbin/srvadmin-uninstall.sh') }
end

# Delete Dell repository files.
%w[ community omsa-indep omsa-specific ].each do |repo|
  yum_repository node['yum']['dell'][repo]['repositoryid'] do
    action :delete
  end
end

# Unlink /opt/dell/srvadmin
directory '/opt/dell/srvadmin' do
  recursive true
  action :delete
end

unless Chef::Config[:solo]
  ruby_block 'remove yum-dell::undo from run_list when there is a conflict' do
    block do
      node.run_list.remove('recipe[yum-dell::undo]')
    end
    only_if { node.run_list.include?('recipe[yum-dell::default]') }
  end
end
