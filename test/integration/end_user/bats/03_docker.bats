load '/opt/bats-support/load.bash'
load '/opt/bats-assert/load.bash'

@test "docker client is installed and invocable" {
  run /bin/bash -c "dojo -c Dojofile.to_be_tested \"docker --version\""
  assert_output --partial "Docker"
  assert_equal "$status" 0
}
