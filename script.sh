#!/usr/bin/env bash
VER="$1"

deb_nodejs_installation() {
  $SUDO curl -fsSL https://deb.nodesource.com/setup_$VER.x | $SUDO bash - 
  $SUDO apt install -y nodejs
  curl -sL https://dl.yarnpkg.com/debian/pubkey.gpg | gpg --dearmor | $SUDO tee /usr/share/keyrings/yarnkey.gpg >/dev/null
  echo "deb [signed-by=/usr/share/keyrings/yarnkey.gpg] https://dl.yarnpkg.com/debian stable main" | $SUDO tee /etc/apt/sources.list.d/yarn.list
  $SUDO apt-get update 
  $SUDO apt-get install -y yarn 


}

rpm_nodejs_installation() {
  $SUDO curl -fsSL https://rpm.nodesource.com/setup_$VER.x | $SUDO bash -
  curl -sL https://dl.yarnpkg.com/rpm/yarn.repo | $SUDO tee /etc/yum.repos.d/yarn.repo
  $SUDO yum -y install yarn 
}

install_debian() {
  $SUDO apt update
  $SUDO apt install -y curl 

  deb_nodejs_installation
  echo " Nodejs is ready for Debian"
  echo " Finished Nodejs-$VER installation"

}

install_ubuntu() {
  $SUDO apt update
  $SUDO apt install -y curl

  deb_nodejs_installation
  echo " Nodejs is ready for Ubuntu"
  echo " Finished Nodejs-$VER installation"

}

install_fedora() {
  $SUDO dnf update -y
  $SUDO dnf -y install dnf-plugins-core curl

  rpm_nodejs_installation
  $SUDO dnf install -y nodejs
  echo " Nodejs is ready for Fedora"
  echo " Finished Nodejs-$VER installation"

}

install_manjaro() {
  $SUDO pacman -Suy 
  $SUDO pacman -S yarn 
  echo " Nodejs is ready for Manjaro"
  echo " Finished Nodejs-$VER installation"

}

install_centos() {
  $SUDO yum update -y
  $SUDO yum install -y yum-utils curl


  rpm_nodejs_installation
  $SUDO yum install -y nodejs
  echo " Nodejs is ready for CentOS"
  echo " Finished Nodejs-$VER installation"

}

usage() {
  echo
  echo "Linux distribution not detected"
  echo "Use: ID=[ubuntu|debian|centos|fedora|manjaro]"
  echo "Other distribution not yet supported"
  echo

}

if [ -f /etc/os-release ]; then
  . /etc/os-release
elif [ -f /etc/debian_version ]; then
  $ID=debian
fi

if [[ $EUID -ne 0 ]]; then
  SUDO='sudo -H'
else
  SUDO=''
fi

case $ID in
        'ubuntu')
                install_ubuntu
        ;;
        'debian')
                install_debian
        ;;
        'centos')
                install_centos
        ;;
        'fedora')
                install_fedora
        ;;
        'manjaro')
                install_manjaro
        ;;
        *)
          usage
        ;;
esac
