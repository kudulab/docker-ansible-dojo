FROM debian:jessie

COPY apt_01proxy /etc/apt/apt.conf.d/01_proxy

# Install image scripts and ide frontend to use
RUN apt-get update && \
  DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends sudo git ca-certificates && \
  git clone --depth 1 -b 0.10.2 https://github.com/ai-traders/ide.git /tmp/ide_git && \
  /tmp/ide_git/ide_image_scripts/src/install.sh && \
  /tmp/ide_git/local_install.sh &&\
  rm -r /tmp/ide_git && \
  echo 'ide ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers

ENV TINI_VERSION v0.9.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /tini
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini.asc /tini.asc
RUN gpg --keyserver ha.pool.sks-keyservers.net --recv-keys 0527A9B7 \
 && gpg --verify /tini.asc && mv /tini /usr/bin/tini && chmod +x /usr/bin/tini &&\
 rm /tini.asc

RUN apt-get update -y  &&\
  DEBIAN_FRONTEND=noninteractive apt-get install -y \
     apt-transport-https \
     ca-certificates \
     curl \
     gnupg2 \
     software-properties-common &&\
     rm -rf /var/lib/apt/lists/* && rm -rf /tmp/* /var/tmp/*

# docker client is needed by ansible docker connector
RUN /bin/bash -c "curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add -" &&\
  echo "deb [arch=amd64] https://download.docker.com/linux/debian jessie stable edge" > /etc/apt/sources.list.d/docker.list &&\
  apt-get update &&\
  DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends\
  docker-ce=17.12.0~ce-0~debian &&\
  rm -Rf /var/lib/docker/* &&\
  rm -rf /var/lib/apt/lists/* && rm -rf /tmp/* /var/tmp/* &&\
  rm -rf /etc/ssh/ssh_host*

# Ansible installing based on https://github.com/William-Yeh/docker-ansible/blob/master/master-debian8/Dockerfile
ENV ANSIBLE_BRANCH_VERSION=stable-2.4
RUN echo "===> Adding Ansible's prerequisites..."         && \
    apt-get update -y  &&  apt-get install --fix-missing  && \
    DEBIAN_FRONTEND=noninteractive  \
        apt-get install --no-install-recommends -y -q  \
                build-essential ca-certificates        \
                python python-pip python-dev           \
                libffi-dev libssl-dev                  \
                libxml2-dev libxslt1-dev zlib1g-dev    \
                git sudo curl                       && \
    apt-get -y --purge remove python-cffi           && \
    \
    \
    echo "===> Fix strange bug under Jessie: cannot import name IncompleteRead"  && \
    easy_install -U pip    && \
    \
    pip install --upgrade cffi pywinrm              && \
    pip install --upgrade pyyaml jinja2 pycrypto tox python-openstackclient yasha && \
    \
    \
    echo "===> Downloading Ansible's source tree..."            && \
    git clone --branch ${ANSIBLE_BRANCH_VERSION} git://github.com/ansible/ansible.git --recursive  && \
    \
    \
    echo "===> Compiling Ansible..."      && \
    cd ansible                            && \
    bash -c 'source ./hacking/env-setup'  && \
    \
    \
    echo "===> Moving useful Ansible stuff to /opt/ansible ..."  && \
    mkdir -p /opt/ansible                && \
    mv /ansible/bin   /opt/ansible/bin   && \
    mv /ansible/lib   /opt/ansible/lib   && \
    mv /ansible/docs  /opt/ansible/docs  && \
    rm -rf /ansible                      && \
    \
    \
    echo "===> Installing handy tools (not absolutely required)..."  && \
    apt-get install -y sshpass openssh-client nano wget curl && \
    \
    \
    echo "===> Clean up..."                                                  && \
    apt-get clean                                                            && \
    rm -rf /var/lib/apt/lists/*                                              && \
    \
    \
    echo "===> Adding hosts for convenience..."  && \
    mkdir -p /etc/ansible                        && \
    echo 'localhost' > /etc/ansible/hosts

COPY etc_ide.d/scripts/* /etc/ide.d/scripts/
COPY ansible.cfg /etc/ansible/

# Install bats
RUN git clone --depth 1 https://github.com/sstephenson/bats.git /opt/bats &&\
  git clone --depth 1 https://github.com/ztombol/bats-support.git /opt/bats-support &&\
  git clone --depth 1 https://github.com/ztombol/bats-assert.git /opt/bats-assert &&\
  /opt/bats/install.sh /usr/local

ENTRYPOINT ["/usr/bin/entrypoint.sh"]
CMD ["/bin/bash"]

# ensure pretty bash prompt and env. variables are set
COPY bashrc /home/ide/.bashrc
COPY profile /home/ide/.profile

ARG this_image_tag_arg
ARG this_image_name_arg
ENV this_image_tag=${this_image_tag_arg} this_image_name=${this_image_name_arg}
