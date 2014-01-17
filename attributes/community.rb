#
# Cookbook Name:: yum-dell
# Attributes:: community
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

default['yum']['dell']['community']['repositoryid'] = 'dell-community'
default['yum']['dell']['community']['description'] = 'Dell Community Repository'
case node['kernel']['machine']
when /i[3456]86/
  default['yum']['dell']['community']['mirrorlist'] = 'http://linux.dell.com/repo/community/mirrors.cgi?' +
    "osname=el#{node['platform_version'].to_i}&basearch=i386"
  default['yum']['dell']['community']['gpgkey'] = 'http://linux.dell.com/repo/community/content/' +
    "el#{node['platform_version'].to_i}-i386/repodata/repomd.xml.key"
else
  default['yum']['dell']['community']['mirrorlist'] = 'http://linux.dell.com/repo/community/mirrors.cgi?' +
    "osname=el#{node['platform_version'].to_i}&basearch=$basearch"
  default['yum']['dell']['community']['gpgkey'] = 'http://linux.dell.com/repo/community/content/' +
    "el#{node['platform_version'].to_i}-#{node['kernel']['machine']}/repodata/repomd.xml.key"
end
default['yum']['dell']['community']['gpgcheck'] = true
default['yum']['dell']['community']['failovermethod'] = 'priority'
