#!/bin/bash

if ! command -v go &> /dev/null
then
    echo "go could not be found. Please install it first"
    exit
fi

# Check the go version
ver=$(go version | { read _ _ v _; echo ${v#go}; })
subver=$(echo $ver | cut -d'.' -f2)

if [[ $subver -lt 18 ]]; then
	echo "Your go version is v$ver, please upgrade to at least v1.18.0 first"
	exit;
fi

shopt -s expand_aliases
_xtrace() {
    case $1 in
        on) set -x ;;
        off) set +x ;;
    esac
}
alias xtrace='{ _xtrace $(cat); } 2>/dev/null <<<'

# Backup the zond wallet.json file from accidental deletion
if [ -f ~/zond/wallet.json ]; then
	walletbackup='wallet.backup.json'
	if [ -f $walletbackup ]; then
		walletbackup=wallet.backup.$(date +'%s').json
	fi
	xtrace on
	cp ~/zond/wallet.json ~/$walletbackup
	xtrace off

	echo "... Backed up wallet to ~/$walletbackup"
fi

if [ -d ~/.zond/ ]; then
	echo -e "\nDo you wish remove your ~/.zond/ directory (keeps state)?"
	select yn in "Yes" "No"; do
	    case $yn in
	        Yes ) 
				xtrace on
				rm -rf ~/.zond
				xtrace off
				echo "... Removed ~/.zond/ directories";
				break;;
	        No ) 
	            echo "... Keeping zond state files (~/.zond)"
	            break;;
	    esac
	done
fi

if [ -d ~/zond/ ]; then
	echo -e "\nDo you want to replace the ~/zond/ directory?"
	select yn in "Yes" "No"; do
	    case $yn in
	        Yes ) 
				xtrace on
				rm -rf ~/zond/
				git clone https://github.com/theQRL/zond ~/zond
				xtrace off
				echo "... Replaced the ~/zond/ directory";
				break;;
	        No ) 
	            echo "... Keeping zond directory (~/zond)"
	            break;;
	    esac
	done
else
	git clone https://github.com/theQRL/zond ~/zond
fi

if [ -n "$walletname" ]; then
	if [ ! -f ~/zond/wallet.json ]; then
		echo "Copying backed up wallet file $walletbackup to ~/zond/wallet.json"
		cp $walletbackup ~/zond/wallet.json
	fi
fi

cd ~/zond
go build ~/zond/cmd/gzond
go build ~/zond/cmd/zond-cli

echo -e "\nWould you like to run ./gzond in the background?"
select yn in "Yes" "No"; do
    case $yn in
        Yes ) 
			xtrace on
            screen -XS zond quit
			screen -S zond -dm ./gzond
			xtrace off		
			break;;
        No ) exit;;
    esac
done

cat << EOF

Congratulations, now have a node setup. So, where to go from here?

- Play with the zond-cli (it's in ~/zond/)
- Read the Zond documentation: https://zond-docs.theqrl.org
- Join the Hackathon: https://www.theqrl.org/events/qrl-hackathon-2022/
EOF