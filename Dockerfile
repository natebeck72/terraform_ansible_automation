FROM alpine:3.16

ENV SSL_CERT_FILE=/etc/ssl/certs/ca-certificates.crt

RUN echo "===> Installing sudo to emulate normal OS behavior..."    && \
    apk --update add sudo                                           && \
    echo "===> Adding Python runtime..."  && \
    apk --update add python3 py3-pip openssl ca-certificates  && \
    apk --update add --virtual build-depandancies \
                python3-dev libffi-dev openssl-dev build-base && \
    pip3 install --upgrade cffi && \
    echo "===> Installing Ansible..."  && \
    pip3 install ansible && \
    echo "===> Installing handy tools" && \
    pip3 install --upgrade pywinrm && \
    apk --update add sshpass openssh-client rsync git curl openssh && \
    echo "===> Removing package list..." && \
    apk del build-depandancies && \
    rm -rf /var/cache/apk/*  && \
    echo "===> Adding hosts for convenience..." && \
    mkdir -p /etc/ansible  && \
    echo 'localhost' > /etc/ansible/hosts &&\
    echo "===> Installing AWS-CLI..." && \
    pip3 install awscli --upgrade --user && \
    echo "===> Installing Azure-CLI..." && \
    apk add gcc musl-dev python3-dev libffi-dev cargo make && \
    pip3 install azure-cli 

ENV TERRAFORM_VERSION=1.2.9
ENV TERRAFORM_SHA256SUM=0e0fc38641addac17103122e1953a9afad764a90e74daf4ff8ceeba4e362f2fb

RUN echo "===> Installing Terraform..."  && \
    curl https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip > terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
    echo "${TERRAFORM_SHA256SUM}  terraform_${TERRAFORM_VERSION}_linux_amd64.zip" > terraform_${TERRAFORM_VERSION}_SHA256SUMS && \
    sha256sum -cs terraform_${TERRAFORM_VERSION}_SHA256SUMS && \
    unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip -d /bin && \
    rm -f terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
    rm -f terraform_${TERRAFORM_VERSION}_SHA256SUMS

RUN echo "===> Cloning ansible repo ..." && \
    echo "===> Installing panos from ansible-galaxy" && \
    ansible-galaxy collection install paloaltonetworks.panos && \
    pip3 install -r ~/.ansible/collections/ansible_collections/paloaltonetworks/panos/requirements.txt

Run echo "===> Cloning Terraform Repo...."






