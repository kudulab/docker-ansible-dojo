FROM debian:10.1-slim

# Install image scripts and dojo frontend to use
ENV DOJO_VERSION=0.5.0
RUN apt-get update && \
  DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends sudo git ca-certificates && \
  git clone --depth 1 -b ${DOJO_VERSION} https://github.com/kudulab/dojo.git /tmp/dojo_git &&\
  /tmp/dojo_git/image_scripts/src/install.sh && \
  rm -r /tmp/dojo_git &&\
  echo 'dojo ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers

ENV TINI_VERSION v0.18.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /tini
RUN mv /tini /usr/bin/tini && chmod +x /usr/bin/tini

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
  echo "deb [arch=amd64] https://download.docker.com/linux/debian buster stable edge" > /etc/apt/sources.list.d/docker.list &&\
  apt-get update &&\
  DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends\
  docker-ce=18.06.3~ce~3-0~debian &&\
  rm -Rf /var/lib/docker/* &&\
  rm -rf /var/lib/apt/lists/* && rm -rf /tmp/* /var/tmp/* &&\
  rm -rf /etc/ssh/ssh_host*

# Ansible installing based on https://github.com/William-Yeh/docker-ansible/blob/master/master-debian9/Dockerfile
RUN echo "===> Installing python, sudo, and supporting tools..."  && \
    apt-get update -y  &&  apt-get install --fix-missing          && \
    DEBIAN_FRONTEND=noninteractive         \
    apt-get install -y                     \
        python python-yaml sudo            \
        curl gcc python-pip python-dev libffi-dev libssl-dev  && \
    apt-get -y --purge remove python-cffi          && \
    pip install --upgrade pycrypto cffi pywinrm    && \
    \
    \
    \
    echo "===> Installing Ansible..."   && \
    pip install ansible                 && \
    \
    \
    \
    echo "===> Installing handy tools (not absolutely required)..."  && \
    apt-get install -y sshpass openssh-client  && \
    \
    \
    echo "===> Removing unused APT resources..."                  && \
    apt-get clean                                                 && \
    rm -rf /var/lib/apt/lists/*  /tmp/*                           && \
    \
    \
    echo "===> Adding hosts for convenience..."        && \
    mkdir -p /etc/ansible                              && \
    echo 'localhost' > /etc/ansible/hosts

# Allow Ansible to support docker related modules
RUN pip uninstall backports.ssl-match-hostname --yes &&\
  apt-get update &&\
  DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends python-backports.ssl-match-hostname &&\
  apt-get clean  &&\
  rm -rf /var/lib/apt/lists/*  /tmp/*  &&\
  pip install docker==4.0.2 &&\
  usermod -a -G docker dojo

# Install handy tools
RUN apt-get update &&\
  DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends nano wget &&\
  apt-get clean  &&\
  rm -rf /var/lib/apt/lists/*  /tmp/*

COPY etc_dojo.d/scripts/* /etc/dojo.d/scripts/
COPY ansible.cfg /etc/ansible/

# Install bats
RUN git clone --depth 1 https://github.com/sstephenson/bats.git /opt/bats &&\
  git clone --depth 1 https://github.com/ztombol/bats-support.git /opt/bats-support &&\
  git clone --depth 1 https://github.com/ztombol/bats-assert.git /opt/bats-assert &&\
  /opt/bats/install.sh /usr/local

ENTRYPOINT ["/usr/bin/tini", "-g", "--", "/usr/bin/entrypoint.sh"]
CMD ["/bin/bash"]

# ensure pretty bash prompt and env. variables are set
COPY bashrc /home/dojo/.bashrc
COPY profile /home/dojo/.profile
