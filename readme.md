# Zond Init

It's not recommended to install things without reading it, so fist make sure you read the [init.sh](./init.sh) file.

## 1. Install requirements

**Ubuntu 20.04**

```bash
sudo apt update
sudo apt install build-essential
```

If you have golang installed previously from apt, uninstall it first

```
sudo apt autoremove golang
```

Then install the snap version of go

```
sudo snap install --classic go
```

And replace shell

```
exec bash
```

## 2. Install/reinstall Zond

It's recommended to use the init script as it's careful not do do things destructively.

```bash
bash <(curl -s https://raw.githubusercontent.com/jackalyst/zond-init/main/init.sh)
```

For those that are installing on an Ubuntu 20.04/22.04 VPS, there's a specific ubuntu install script

```bash
bash <(curl -s https://raw.githubusercontent.com/jackalyst/zond-init/main/ubuntu.sh)
```

Both will download and install the Zond node (at this time Zond Public Devnet). 

## A note on the Raspberry Pi

There's a few modifications required to have it work on the Raspberry Pi, which I'm not sure would make for a reliable node on the network so I'm not sharing it at this time. 