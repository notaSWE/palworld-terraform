#!/bin/bash

# Redirect stdout (and stderr) to a log file
exec > /var/log/startup_script.log 2>&1

echo "Running apt update and upgrade..."
apt update && apt upgrade -y
sleep 5

echo "Installing software-properties-common and expect..."
apt install -y software-properties-common expect
sleep 5

echo "Adding non-free repository..."
apt-add-repository non-free
sleep 5

echo "Adding i386 architecture..."
dpkg --add-architecture i386
sleep 5

echo "Running apt update..."
apt update
sleep 5

echo "Preparing to run expect script for steamcmd installation..."

# Use expect to handle steamcmd installation and accept license agreement
/usr/bin/expect <<EOF
set timeout -1
exp_internal 1  # Enable expect internal debugging

spawn apt-get install -y steamcmd

# Handling the Steam License Agreement
expect {
    "*Do you agree to all terms of the Steam License Agreement?*" {
        # Simulate pressing "2" for "I AGREE" and then Enter
        send "2\r"
        exp_continue
    }
    eof
}
EOF

echo "Creating a new user for Steam without a password..."
sudo useradd -m -d /home/steam steam
sleep 5

echo "Running SteamCMD commands as the steam user..."
sudo -u steam /usr/games/steamcmd +login anonymous +app_update 2394010 validate +quit
sleep 5
sudo -u steam ln -s /usr/games/steamcmd/linux32 /home/steam/.steam/sdk32 || echo "sdk32 already exists"
sudo -u steam ln -s /usr/games/steamcmd/linux64 /home/steam/.steam/sdk64 || echo "sdk64 already exists"

echo "Checking for PalServer directory..."
if [ -d "/home/steam/.steam/SteamApps/common/PalServer" ]; then
    echo "Starting PalServer..."
    cd /home/steam/.steam/SteamApps/common/PalServer
    sudo -u steam screen -dmS palworld-running ./PalServer.sh -useperfthreads -NoAsyncLoadingThread -UseMultithreadForDS
else
    echo "PalServer directory not found"
    exit 1
fi

echo "Startup script completed."
