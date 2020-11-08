load '/opt/bats-support/load.bash'
load '/opt/bats-assert/load.bash'

@test "ansible is installed and invocable" {
  run /bin/bash -c "dojo -c Dojofile.to_be_tested \"ansible --version\""
  assert_output --partial "ansible 2.10.3"
  assert_output --partial "python version = 3"
  assert_equal "$status" 0
}

@test "yamllint is installed and invocable" {
  run /bin/bash -c "dojo -c Dojofile.to_be_tested \"yamllint .\""
  assert_output --partial "warning"
  assert_equal "$status" 0
}

@test "ansible-lint is installed and invocable" {
  run /bin/bash -c "dojo -c Dojofile.to_be_tested \"ansible-lint -x idempotency playbook.yml\""
  assert_equal "$status" 0
}
