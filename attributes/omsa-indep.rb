#
# Cookbook Name:: yum-dell
# Attributes:: omsa-indep
#
# Copyright 2010, Eric G. Wolfe
# Copyright 2010, Tippr Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

default['yum']['dell']['omsa-indep']['repositoryid'] = 'dell-omsa-indep'
default['yum']['dell']['omsa-indep']['description'] = 'Dell OMSA repository - Hardware independent'
case node['kernel']['machine']
when /i[3456]86/
  default['yum']['dell']['omsa-indep']['mirrorlist'] = 'http://linux.dell.com/repo/hardware/latest/mirrors.cgi?' +
    "osname=el#{node['platform_version'].to_i}&basearch=i386&native=1&dellsysidpluginver=$dellsysidpluginver"
else
  default['yum']['dell']['omsa-indep']['mirrorlist'] = 'http://linux.dell.com/repo/hardware/latest/mirrors.cgi?' +
    "osname=el#{node['platform_version'].to_i}&basearch=$basearch&native=1&dellsysidpluginver=$dellsysidpluginver"
end
default['yum']['dell']['omsa-indep']['gpgkey'] = 'http://linux.dell.com/repo/hardware/latest/public.key'
default['yum']['dell']['omsa-indep']['gpgcheck'] = true
default['yum']['dell']['omsa-indep']['failovermethod'] = 'priority'
