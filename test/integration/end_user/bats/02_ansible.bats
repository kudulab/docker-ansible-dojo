load '/opt/bats-support/load.bash'
load '/opt/bats-assert/load.bash'

@test "ansible is installed and invocable" {
  run /bin/bash -c "ide --idefile Idefile.to_be_tested \"ansible --version\""
  assert_output --partial "ansible"
  assert_equal "$status" 0
}
