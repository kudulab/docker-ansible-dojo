load '/opt/bats-support/load.bash'
load '/opt/bats-assert/load.bash'

@test "/usr/bin/entrypoint.sh returns 0" {
  run /bin/bash -c "ide --idefile Idefile.to_be_tested \"pwd && whoami\""
  # this is printed on test failure
  echo "output: $output"
  assert_output --partial "ide init finished"
  assert_output --partial "ansibleide"
  refute_output --partial "root"
  assert_equal "$status" 0
}

@test "can git clone infra-openstack2 from git server" {
  run /bin/bash -c "ide --idefile Idefile.to_be_tested \"rm -rf infra-openstack2 &&\
    git clone git@git.ai-traders.com:openstack/infra-openstack2.git\""
  assert_output --partial "Cloning into 'infra-openstack2'..."
  assert_equal "$status" 0
}

@test "can git clone from github" {
  run /bin/bash -c "ide --idefile Idefile.to_be_tested \"rm -rf kolla &&\
    git clone git@github.com:ai-traders/kolla.git\""
  assert_output --partial "Cloning into 'kolla'..."
  assert_equal "$status" 0
}
