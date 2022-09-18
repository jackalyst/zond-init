#!/bin/bash

bootstrap=https://raw.githubusercontent.com/jackalyst/zond-init/main/bootstrap-devnet.tar.xz

echo -e "Warning, this script is meant for fresh systems and may be destructive to files that already exist. Do you wish to proceed?"
select yn in "Yes" "No"; do
    case $yn in
        Yes ) 
            echo "... Great. Lets begin";
            break;;
        No ) exit;;
    esac
done

echo "... Installing requirements"
sleep 2
sudo apt -y update
sudo apt -y upgrade
sudo apt install -y build-essential
sudo apt autoremove -y golang
sudo snap install go --classic
source ~/.profile
source ~/.bashrc

echo "... Removing key files"
sleep 2
rm -rf ~/.zond
rm -rf ~/zond

echo "... Downloading zond"
git clone https://github.com/theQRL/zond ~/zond

echo "... Building zond"
sleep 2

cd ~/zond
go build ~/zond/cmd/gzond
go build ~/zond/cmd/zond-cli


if [ -f ~/zond/gzond ]; then
    echo "Congratulations, it looks like things were installed successfully"
else 
    echo "Something may have gone wrong"
fi