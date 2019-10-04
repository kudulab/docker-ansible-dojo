load '/opt/bats-support/load.bash'
load '/opt/bats-assert/load.bash'

@test "make is installed" {
  run /bin/bash -c "dojo -c Dojofile.to_be_tested \"make --version\""
  assert_output --partial "GNU Make 4"
  assert_equal "$status" 0
}
