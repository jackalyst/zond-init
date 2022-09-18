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


echo "... Downloading zond and bootstrap files"
sleep 2

mkdir -p ~/Downloads/bootstrap-devnet/
git clone https://github.com/theQRL/zond ~/zond
wget https://raw.githubusercontent.com/jackalyst/zond-init/main/bootstrap-devnet.tar.xz -O ~/Downloads/bootstrap-devnet.tar.xz
tar -xf ~/Downloads/bootstrap-devnet.tar.xz -C ~/Downloads/bootstrap-devnet/ --strip-components=1

echo "... Applying modifications"
sleep 2

cp -r ~/Downloads/bootstrap-devnet/block/genesis/devnet/ ~/zond/block/genesis/
cp ~/Downloads/bootstrap-devnet/config/config.go ~/zond/config/config.go
patch -u ~/zond/config/config.go -p0 <<'EOF'
@@ -178,7 +178,7 @@
 func GetUserConfig() (userConf *UserConfig) {
 	node := &NodeConfig{
 		EnablePeerDiscovery:     true,
-		PeerList:                []string{},
+		PeerList:                []string{"/ip4/45.76.43.83/tcp/15005/p2p/QmU6Uo93bSgU7bA8bkbdNhSfbmp7S5XJEcSqgrdLzH6ksT"},
 		BindingIP:               "0.0.0.0",
 		LocalPort:               15005,
 		PublicPort:              15005,
EOF

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