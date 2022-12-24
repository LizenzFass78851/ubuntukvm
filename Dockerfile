FROM ubuntu:18.04
ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update -y 

RUN apt-get install -y qemu-kvm libvirt-daemon-system libvirt-dev libvirt-clients bridge-utils ovmf 

RUN apt-get install -y linux-image-$(uname -r) 
#RUN apt-get install -y wget && \
#  wget https://launchpad.net/~canonical-signing/+archive/ubuntu/primary/+build/24871899/+files/linux-image-5.15.0-56-generic_5.15.0-56.62_amd64.deb && \
#  wget https://launchpad.net/~canonical-kernel-team/+archive/ubuntu/ppa2/+build/24861195/+files/linux-modules-5.15.0-56-generic_5.15.0-56.62_amd64.deb && \
#  wget https://launchpad.net/ubuntu/+archive/primary/+files/linux-base_4.5ubuntu9_all.deb
#RUN dpkg -i \
#  ./linux-image-5.15.0-56-generic_5.15.0-56.62_amd64.deb \
#  ./linux-modules-5.15.0-56-generic_5.15.0-56.62_amd64.deb \
#  ./linux-base_4.5ubuntu9_all.deb && \
#  rm linux*.deb

RUN apt-get install -y curl net-tools jq build-essential

RUN apt-get autoclean 
RUN apt-get autoremove 

RUN curl -O https://releases.hashicorp.com/vagrant/$(curl -s https://checkpoint-api.hashicorp.com/v1/check/vagrant | jq -r -M '.current_version')/vagrant_$(curl -s https://checkpoint-api.hashicorp.com/v1/check/vagrant | jq -r -M '.current_version')-1_amd64.deb 
RUN dpkg -i vagrant_$(curl -s https://checkpoint-api.hashicorp.com/v1/check/vagrant | jq -r -M '.current_version')-1_amd64.deb 
#RUN curl -O https://releases.hashicorp.com/vagrant/2.3.0/vagrant_2.3.0-1_amd64.deb
#RUN dpkg -i ./vagrant_2.3.0-1_amd64.deb 

RUN vagrant plugin install vagrant-libvirt 
RUN vagrant box add --provider libvirt peru/windows-10-enterprise-x64-eval
RUN vagrant init peru/windows-10-enterprise-x64-eval 

EXPOSE 3389
COPY startup.sh /
COPY startup2.sh /
RUN chmod +x /startup*.sh
ENTRYPOINT ["/startup.sh"]
