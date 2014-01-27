#
# Cookbook Name:: yum-dell
# Recipe:: default
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

# Detection of Dell hardware depends on dmidecode
package 'dmidecode'

# Community supported software.  Does not require Dell Hardware.
yum_repository node['yum']['dell']['community']['repositoryid'] do
  description node['yum']['dell']['community']['description']
  mirrorlist node['yum']['dell']['community']['mirrorlist']
  gpgkey node['yum']['dell']['community']['gpgkey']
  gpgcheck node['yum']['dell']['community']['gpgcheck']
  failovermethod node['yum']['dell']['community']['failovermethod']
  action :create
end

# Dell Hardware/OMSA repositories.  Requires Dell Hardware.
%w[omsa-indep omsa-specific].each do |repo|
  yum_repository node['yum']['dell'][repo]['repositoryid'] do
    description node['yum']['dell'][repo]['description']
    mirrorlist node['yum']['dell'][repo]['mirrorlist']
    gpgkey node['yum']['dell'][repo]['gpgkey']
    gpgcheck node['yum']['dell'][repo]['gpgcheck']
    failovermethod node['yum']['dell'][repo]['failovermethod']
    only_if { node['yum']['dell']['enabled'] }
  end
end

# Install packages, srvadmin-all by default
node['yum']['dell']['packages'].each do |dell_package|
  package dell_package
end
