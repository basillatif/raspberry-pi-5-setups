# Raspberry Pi 5 Setups

This repository is a notebook for building and documenting Raspberry Pi 5
systems. Start with a clean Raspberry Pi OS installation, get remote access
working, and then add one project at a time.

## What you need

- Raspberry Pi 5
- A quality USB-C power supply; the official 27 W supply is the simplest choice
- Active Cooler or a Pi 5 case with a fan
- 32 GB or larger microSD card
- Another computer with an SD card reader
- Optional for local setup: micro-HDMI cable, monitor, keyboard, and mouse

## 1. Write Raspberry Pi OS

1. Install [Raspberry Pi Imager](https://www.raspberrypi.com/software/).
2. Choose your Raspberry Pi 5.
3. Choose **Raspberry Pi OS (64-bit)**.
   - Pick the desktop edition if you will use a monitor.
   - Pick Raspberry Pi OS Lite for a headless server.
4. Choose the microSD card.
5. In OS customisation, set:
   - A hostname, such as `pi5`
   - Your username and a unique password
   - Wi-Fi name, password, and country if not using Ethernet
   - Your time zone and keyboard layout
   - SSH using password authentication for the first login
6. Write the card and let Imager verify it.

Do not store passwords, Wi-Fi credentials, private keys, or copied `.env` files
in this repository.

## 2. First boot

Insert the microSD card, connect Ethernet or the local peripherals, and connect
power last. The first boot can take a few minutes.

For a headless setup, find the Pi on your network and connect from Terminal:

```bash
ping pi5.local
ssh YOUR_USERNAME@pi5.local
```

If `.local` discovery does not work, find the Pi's IP address in your router's
device list and use `ssh YOUR_USERNAME@192.168.x.x`.

## 3. Update and inspect

Run these commands on the Pi:

```bash
sudo apt update
sudo apt full-upgrade -y
sudo reboot
```

Reconnect after the reboot, then capture a quick baseline:

```bash
hostnamectl
cat /etc/os-release
uname -a
vcgencmd measure_temp
df -h /
free -h
```

## 4. Basic configuration

Open the supported configuration menu when you need to change interfaces,
localisation, or boot behavior:

```bash
sudo raspi-config
```

Once SSH key login works, disable password-based SSH login for a machine that
will be exposed beyond your trusted home network. Do not expose port 22 directly
to the public internet.

## First milestone

The base setup is complete when all of these are true:

- The Pi boots without an undervoltage warning
- The fan or cooler is installed and temperatures look reasonable
- Network access survives a reboot
- SSH login works
- Raspberry Pi OS is fully updated

From there, choose one role for the machine: desktop, Home Assistant, Pi-hole,
NAS, media server, Docker host, web server, retro gaming, or electronics/GPIO
development. Each role should get its own folder and setup notes in this repo.

## Official references

- [Raspberry Pi getting started guide](https://www.raspberrypi.com/documentation/computers/getting-started.html)
- [Raspberry Pi computer hardware documentation](https://www.raspberrypi.com/documentation/computers/raspberry-pi.html)
