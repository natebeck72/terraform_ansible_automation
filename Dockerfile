FROM alpine:3.17.2

ENV SSL_CERT_FILE=/etc/ssl/certs/ca-certificates.crt

RUN echo "===> Installing sudo to emulate normal OS behavior ..."    && \
    apk --update add sudo

RUN echo "===> Adding Python runtime ..."  && \
    apk --update add python3 py3-pip openssl ca-certificates libssh-dev && \
    apk --update add --virtual build-depandancies \
                python3-dev libffi-dev openssl-dev build-base && \
    pip3 install --upgrade cffi

RUN echo "===> Installing Ansible ..."  && \
    pip3 install ansible

RUN echo "===> Installing handy tools ..." && \
    pip3 install --upgrade pywinrm && \
    pip3 install requests-toolbelt && \
    apk --update add sshpass openssh-client rsync git curl openssh

RUN echo "===> Installing AWS-CLI ..." && \
    apk --no-cache add aws-cli && \
    mkdir ~/.aws && \
    ln -s /credentials/config ~/.aws/config && \
    ln -s /credentials/credentials ~/.aws/credentials

RUN echo "===> Installing Azure-CLI ..." && \
    apk add gcc musl-dev python3-dev libffi-dev cargo make && \
    pip3 install azure-cli 

RUN echo "===> Removing package list ..." && \
    apk del build-depandancies && \
    rm -rf /var/cache/apk/*

RUN echo "===> Adding hosts for convenience ..." && \
    mkdir -p /etc/ansible  && \
    echo 'localhost' > /etc/ansible/hosts

RUN echo "===>  Installing Rover ..." && \
    wget https://github.com/im2nguyen/rover/releases/download/v0.3.3/rover_0.3.3_linux_amd64.zip && \
    unzip rover_0.3.3_linux_amd64.zip  -d /bin && \
    rm -f rover_0.3.3_linux_amd64.zip && \
    mv /bin/rover_v0.3.3 /bin/rover && \
    rm -f /bin/LICENSE && \
    rm -f /bin/README.md


ENV TERRAFORM_VERSION=1.3.9
ENV TERRAFORM_SHA256SUM=53048fa573effdd8f2a59b726234c6f450491fe0ded6931e9f4c6e3df6eece56

RUN echo "===> Installing Terraform ..."  && \
    curl https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip > terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
    echo "${TERRAFORM_SHA256SUM}  terraform_${TERRAFORM_VERSION}_linux_amd64.zip" > terraform_${TERRAFORM_VERSION}_SHA256SUMS && \
    sha256sum -cs terraform_${TERRAFORM_VERSION}_SHA256SUMS && \
    unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip -d /bin && \
    rm -f terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
    rm -f terraform_${TERRAFORM_VERSION}_SHA256SUMS

RUN echo "===> Cloning ansible repo ..." && \
    git clone https://github.com/natebeck72/Ansible_poc_automation-docker.git

RUN echo "===> Installing panos from ansible-galaxy ..." && \
    ansible-galaxy collection install paloaltonetworks.panos && \
    pip3 install -r ~/.ansible/collections/ansible_collections/paloaltonetworks/panos/requirements.txt

RUN echo "===> Installing other required ansible collections..." && \
    ansible-galaxy collection install ansible.netcommon && \
    pip3 install -r ~/.ansible/collections/ansible_collections/ansible/netcommon/requirements.txt && \
    pip3 install -r ~/.ansible/collections/ansible_collections/ansible/utils/requirements.txt 

Run echo "===> Cloning Terraform Repo ..." && \
    git clone https://github.com/natebeck72/TF_POC_AutomationDocker.git && \
    cd /TF_POC_AutomationDocker && \
    terraform init