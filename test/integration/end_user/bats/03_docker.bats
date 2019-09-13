load '/opt/bats-support/load.bash'
load '/opt/bats-assert/load.bash'

@test "docker client is installed and invocable" {
  run /bin/bash -c "dojo -c Dojofile.to_be_tested \"docker --version\""
  assert_output --partial "Docker"
  assert_equal "$status" 0
}

@test "ansible can manage docker in a playbook" {
  run /bin/bash -c "dojo -c Dojofile.to_be_tested \"sudo service docker start && ansible-playbook -i ./hosts ./playbook.yml && docker images\""
  assert_output --partial "failed=0"
  refute_output --partial "ok=0"
  refute_output --partial "No module named docker"
  refute_output --partial "Error"
  assert_output --partial "alpine"
  assert_output --partial "3.8"
  assert_equal "$status" 0
}
