#!/usr/bin/env bats

@test "dell-community.repo file exists" {
  run test -f /etc/yum.repos.d/dell-community.repo
  [ "$status" -eq 0 ]
}

@test "dell-omsa-indep.repo file exists" {
  run test -f /etc/yum.repos.d/dell-omsa-indep.repo
  [ "$status" -eq 0 ]
}

@test "dell-omsa-specific.repo file exists" {
  run test -f /etc/yum.repos.d/dell-omsa-specific.repo
  [ "$status" -eq 0 ]
}

@test "srvadmin-services.sh exists" {
  run test -x /opt/dell/srvadmin/sbin/srvadmin-services.sh
  [ "$status" -eq 0 ]
}

@test "can install dkms" {
  run yum -y install dkms 
  [ "$status" -eq 0 ]
}
