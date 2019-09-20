load '/opt/bats-support/load.bash'
load '/opt/bats-assert/load.bash'

@test "/usr/bin/entrypoint.sh returns 0" {
  run /bin/bash -c "dojo -c Dojofile.to_be_tested \"pwd && whoami\""
  # this is printed on test failure
  echo "output: $output"
  assert_output --partial "dojo init finished"
  assert_output --partial "ansible-dojo"
  refute_output --partial "root"
  assert_equal "$status" 0
}

@test "can git clone from github" {
  run /bin/bash -c "dojo -c Dojofile.to_be_tested \"rm -rf dojo-git-repo &&\
    git clone https://github.com/kudulab/dojo.git dojo-git-repo; rm -rf dojo-git-repo\""
  assert_output --partial "Cloning into 'dojo-git-repo'..."
  assert_equal "$status" 0
}
