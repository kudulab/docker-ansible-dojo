FROM debian:jessie

COPY apt_01proxy /etc/apt/apt.conf.d/01_proxy

RUN apt-get update && \
  DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends sudo git ca-certificates && \
  git clone --depth 1 -b 0.10.2 https://github.com/ai-traders/ide.git /tmp/ide_git && \
  /tmp/ide_git/ide_image_scripts/src/install.sh && \
  rm -r /tmp/ide_git && \
  echo 'ide ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers

ENV TINI_VERSION v0.9.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /tini
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini.asc /tini.asc
RUN gpg --keyserver ha.pool.sks-keyservers.net --recv-keys 0527A9B7 \
 && gpg --verify /tini.asc && mv /tini /usr/bin/tini && chmod +x /usr/bin/tini &&\
 rm /tini.asc

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
    pip install --upgrade pyyaml jinja2 pycrypto tox  && \
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

ENTRYPOINT ["/usr/bin/entrypoint.sh"]
CMD ["/bin/bash"]

# ensure pretty bash prompt and env. variables are set
COPY bashrc /home/ide/.bashrc
COPY profile /home/ide/.profile
