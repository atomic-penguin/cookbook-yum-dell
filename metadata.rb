maintainer       'Eric G. Wolfe'
maintainer_email 'wolfe21@marshall.edu'
license          'Apache 2.0'
description      'Installs and configures EPEL, ELFF, Dell, and VMware yum repositories.'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '3.0.0'
depends          'yum'
name             'yum-dell'
recipe 'yum-dell::default', 'Installs Dell OpenManage and optionally firmware components.'
recipe 'yum-dell::omsa', 'Reverses default recipe'

%w{ redhat centos scientific amazon oracle }.each do |os|
  supports os, '>= 5.0'
end
