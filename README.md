# docker-ansible-dojo

This is a docker [dojo](https://github.com/kudulab/dojo) image to be used by administrator operating with ansible.
In ansible terms, this provides the controller environment.

## Specification

 * Ansible `2.8` is installed from git source. So it is easy to fork and patch.
 * docker CLI for ansible docker connector to work
 * bats for minimal testing support

## Usage
1. [Install docker](https://docs.docker.com/install/), if you haven't already.
2. Install [Dojo](https://github.com/kudulab/dojo#installation) it is a self-contained binary, so just place it somewhere on the `PATH`.
On **Linux**:
```bash
DOJO_VERSION=0.5.0
wget -O dojo https://github.com/kudulab/dojo/releases/download/${DOJO_VERSION}/dojo_linux_amd64
sudo mv dojo /usr/local/bin
sudo chmod +x /usr/local/bin/dojo
```
3. Provide a Dojofile:
```
DOJO_DOCKER_IMAGE="kudulab/ansible-dojo:1.0.0"
```
4. Create and enter the container by running `dojo` at the root of project.
5. Work with ansible as usual:
```bash
ansible-playbook ansible/site.yml -i inventory/myinv.yml --tags web
ansible-doc file
ansible all -m ping -i inventory/myinv.yml
ansible-lint -x idempotency playbook.yml
yamllint .
```

By default, current directory in docker container is `/dojo/work`.

### Docker daemon inside the ansible-dojo container
In order to have docker daemon running in the ansible-dojo container, you need
 to add to Dojofile:
```
DOJO_DOCKER_OPTIONS="--privileged -v /some/local/dir:/var/lib/docker"
```

And then start the docker daemon inside the ansible-dojo container with:
```
sudo service docker start
```

## License

Copyright 2019 Ewa Czechowska, Tomasz Sętkowski

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
