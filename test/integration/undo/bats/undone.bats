#!/usr/bin/env bats

@test "dell-community.repo does not exist" {
  run test ! -f /etc/yum.repos.d/dell-community.repo
  [ "$status" -eq 0 ]
}

@test "dell-omsa-indep.repo does not exist" {
  run test ! -f /etc/yum.repos.d/dell-omsa-indep.repo
  [ "$status" -eq 0 ]
}

@test "dell-omsa-specific.repo does not exist" {
  run test ! -f /etc/yum.repos.d/dell-omsa-specific.repo
  [ "$status" -eq 0 ]
}

@test "cannot install dkms" {
  run yum -y install dkms
  [ "$status" -eq 1 ]
}

@test "/opt/dell/srvadmin has been unlinked" {
  run test ! -d /opt/dell/srvadmin
  [ "$status" -eq 0 ]
}
