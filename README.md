yum-dell Cookbook
======================

[![Build Status](https://secure.travis-ci.org/atomic-penguin/cookbook-yum-dell.png?branch=master)](http://travis-ci.org/atomic-penguin/cookbook-yum-dell)

Configures Dell community and hardware/OMSA (Open Manage Server Assistant)
repositories.  See http://linux.dell.com for full details.

The default recipe configures community and hardware repositories, and installs
OMSA on Dell hardware.  On non-Dell hardware, only the community repository is
configured.

The community repository provides non-Dell specific
dkms (Dynamic Kernel Module Support), and SMBIOS (Systems Management BIOS)
library packages.

The hardware repositories contain hardware drivers, firmware binaries,
BIOS updates, and OMSA software specific to Dell hardware.

Requirements
------------

There is a dependency on the dmidecode package so that Ohai can detect Dell
hardware.

This cookbook depends on the `yum_repository` provider from the `yum` cookbook.
You need to have a RHEL family platform, and yum, to use the cookbook.

#### cookbooks 

- `yum` - Opscode maintained 3.0+ cookbook 

Attributes
----------
The following are overridable attributes, in the `yum['dell']` namespace.

#### yum-dell::default

<table>
  <tr>
    <th>Key</th>
    <th>Type</th>
    <th>Description</th>
    <th>Default</th>
  </tr>
  <tr>
    <td><tt>['yum']['dell']['enabled']</tt></td>
    <td>Boolean</td>
    <td>Whether Dell hardware was detected via Ohai, or not.</td>
    <td><tt>Value depends on hardware.</tt></td>
  </tr>
  <tr>
    <td><tt>['yum']['dell']['packages']</tt></td>
    <td>Array</td>
    <td>An array of packages from Dell repositories to install.</td>
    <td><tt>srvadmin-all</tt> on Dell hardware. <tt>Empty</tt> on non-Dell hardware.</td>
  </tr>
</table>

Each Dell repository has its own attribute namespace.  It is recommended
that you not override these, unless you have a local mirror.  The attributes
correspond to the parameters in the `yum_repository` library.

#### per-repository attributes

<table>
  <tr>
    <th>Namespace</th>
    <th>Corresponding repository</th>
  </tr>
  <tr>
    <td><tt>yum['dell']['community']</tt></td>
    <td>Community supported Open Source software.</td>
  </tr>
  <tr>
    <td><tt>yum['dell']['omsa-indep']</tt></td>
    <td>Dell OMSA repository, Hardware independent</td>
  </tr>
  <tr>
    <td><tt>yum['dell']['omsa-specific']</tt></td>
    <td>Dell OMSA repository, Hardware specific</td>
  </tr>
</table>

<table>
  <tr>
    <th>Key</th>
    <th>Type</th>
    <th>Description</th>
    <th>Default</th>
  </tr>
  <tr>
    <td><tt>$namespace['repositoryid']</tt></td>
    <td>String</td>
    <td>Filename of repo file.</td>
    <td><tt>dell-community</tt>, <tt>dell-omsa-indep</tt>, <tt>dell-omsa-specific</tt> respectively</td>
  </tr>
  <tr>
    <td><tt>$namespace['description']</tt></td>
    <td>String</td>
    <td>Human readable description for repository.</td>
    <td>e.g. Dell Community Repository</td>
  </tr>
  <tr>
    <td><tt>$namespace['mirrorlist']</tt></td>
    <td>String</td>
    <td>URL with list of mirrors.</td>
    <td>repository specific</td>
  </tr>
  <tr>
    <td><tt>$namespace['gpgkey']</tt></td>
    <td>String</td>
    <td>URL of public signing key for package</td>
    <td>repository specific</td>
  </tr>
  <tr>
    <td><tt>$namespace['gpgcheck']</tt></td>
    <td>Boolean</td>
    <td>Whether, or not, to check the provided gpgkey</td>
    <td><tt>true</tt></td>
  </tr>
  <tr>
    <td><tt>$namespace['failovermethod']</tt></td>
    <td>List</td>
    <td>Method to choose next mirror on failure.  Either, priority or roundrobin.</td>
    <td><tt>priority</tt></td>
  </tr>
</table>

Usage
-----
#### yum-corporate::default

Optionally, set attributes in a role, and
include `yum-dell` in your node's `run_list`:

```
default_attributes(
  :yum => {
    :dell => {
      :packages => [ "srvadmin-base" ]
    }
  }
)
```

```json
{
  "name":"my_node",
  "run_list": [
    "recipe[yum-dell]"
  ]
}
```

#### yum-dell::undo

This recipe does the opposite action of yum-corporate::default.

Specifically, this recipe runs srvadmin-uninstall.sh to remove
all OMSA comoponents.  It deletes all Dell repository `.repo`
files.  Finally, it purges any leftover settings left after
uninstall in `/opt/dell/srvadmin`.

Contributing
------------

1. Fork the repository on Github
2. Create a named feature branch (like `add_component_x`)
3. Write your change
4. Write tests for your change (if applicable)
5. Run the tests, ensuring they all pass
6. Submit a Pull Request using Github

License and Authors
-------------------

Author:: Eric G. Wolfe
Copyright:: 2010-2011

Author:: Tippr, Inc.
Copyright:: 2010

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at
    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
