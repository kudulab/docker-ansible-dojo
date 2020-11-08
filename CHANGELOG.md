### 1.5.0 (2020-Nov-08)

* Ansible 2.10.3
* Set Ansible default interpreter to python3
* Use Dojo image scripts 0.10.2

### 1.4.0 (2019-Oct-09)

 * Added rsync so that ansible can sync directories from control host to remotes

### 1.3.0 (2019-Oct-04)

* add Make to specification (explicitly install it and add a test)

### 1.2.0 (2019-Sep-20)

* install tools to lint test Ansible playbooks: ansible-lint, yamllint

### 1.1.0 (2019-Sep-13)

* fix tests so that they are actually run
* fix tests so that they pass
* allow Ansible to support docker related modules - install python docker sdk
 and add user dojo to group docker
* use newer base image: debian:10.1-slim
* use dojo scripts from Dojo 0.6.0

### 1.0.0 (2019-May-09)

 * prepare for public usage, push to `kudulab/ansible-dojo`
 * removed AIT references
 * ported from IDE to Dojo
 * upgraded docker client to `18.06.3~ce~3-0~debian`
 * upgraded ansible to 2.8

### 0.3.0 (2018-Mar-18)

 * updated ansible to 2.5

### 0.2.1 (2018-Feb-16)

 * added bats
 * added IDE CLI
 * added yasha

### 0.2.0 (2018-Jan-19)

 * Fix base registry port.
 * added docker client
 * added python openstack client

### 0.1.0 (2018-Jan-11)

Initial release
