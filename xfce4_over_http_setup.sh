#!/usr/bin/env bash

# Description: this script will setup a desktop environment that will be accessible over HTTP
# Author: istackz
# Date: 1/19/2025

<<NOTES

        Before running this script ensure you are running the appropriate docker/podman run command.
        example: docker run -itb --hostname <hostname> --name <container-name> -p <host-port>:<container-port/80> --rm  --replace (optional) --privileged (podman only) rockylinux:latest

        Also be sure to create the necessary firewall rules to allow the port through.
        Lastly, once the script has finished running, go to your web browser and input http://<hostip>:<hostport> in the url to view the desktop environment.

	Sources:

		1. https://stackoverflow.com/questions/16296753/can-you-run-gui-applications-in-a-linux-docker-container --> comment by user5539487 
		2. https://github.com/ConSol/docker-headless-vnc-container/blob/master/src/rocky/install/icewm_ui.sh --> look through the src folder of this repo. (useful)
NOTES

# install packages
yum install epel-release ncurses procps-ng net-tools vim -y;
yum install xorg-x11-server-xvfb novnc x11vnc -y;
yum install @Xfce -y;
yum install dbus-x11 -y;

# remove certain packages
yum remove *power* *screensaver* -y;

# remove xfce-polkit.desktop
rm -f /etc/xdg/autostart/xfce-polkit*;

# create .x11vnc directory in $HOME
mkdir -p $HOME/.x11vnc;

# set permission for directory
chmod 700 $HOME/.x11vnc;

# create vnc server password
x11vnc -storepasswd password $HOME/.x11vnc/passwd;

# start virtual display (for containers). For actual browser window size lookup https://www.rapidtables.com/web/tools/window-size.html
Xvfb :1 -screen 0 1600x700x24 2>&1 > $HOME/xvfb.log &;

# set the DISPLAY variable
export DISPLAY=":1";

# launch vnc server
x11vnc -noxdamage -many -display $DISPLAY -rfbport 5900 -rfbauth $HOME/.x11vnc/passwd 2>&1 > $HOME/x11vnc.log  &;

# start novnc HTTP proxy
novnc_proxy --vnc localhost:5900 --listen 80;

# start Xfce desktop
xfce4-session --display $DISPLAY 2>$HOME/xfce4_error.log 1>/dev/null &;

