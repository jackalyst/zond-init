# Zond Init

It's not recommended to install things without reading it, so fist make sure you read the the [init.sh](./init.sh) file.

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

```bash
bash <(curl -s https://raw.githubusercontent.com/jackalyst/zond-init/main/init.sh)
```

From there it will download and install the Zond node (at this time Zond Public Devnet). 