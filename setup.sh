#!/bin/bash

sudo apt-get update

# Install vsftpd, python, python3 and python3-pip
sudo apt-get install -y vsftpd
sudo apt-get install -y python
sudo apt-get install -y python3

# Change SSH config
sudo cp our_sshd_config /etc/ssh/sshd_config
sudo systemctl restart sshd

# Change config to allow anonymous access
sudo cp our_vsftpd.conf /etc/vsftpd.conf
sudo systemctl restart vsftpd

# Create directory and test file for anonymous FTP to read
sudo mkdir -p /var/ftp/pub
sudo chown nobody:nogroup /var/ftp/pub
echo "vsftpd test file" | sudo tee /var/ftp/pub/test.txt

for ((x = 0 ; x < 100 ; x++ )); do sudo touch /var/ftp/pub/"$x"; done

# Make user 'garrett' to run service
sudo useradd garrett
sudo mkdir -p /home/garrett
sudo chown garrett:garrett /home/garrett
sudo usermod -s /bin/bash garrett
sudo echo 'garrett:P@$$w0rd_random_P@$$w0rd_hahaha' | sudo chpasswd

# Change the sudoers file so 'garrett' can run things as root
sudo cp our_sudoers /etc/sudoers

# Install python3 pip in order to install pycrypto
sudo apt-get install -y python3-pip
sudo pip3 install pycrypto

# Move cmd_service to directory
sudo mkdir -p /var/cmd/
sudo cp cmd_service.py /var/cmd/.cmd_service.py
sudo chmod +x /var/cmd/.cmd_service.py

# Move scripts to working folder
sudo cp pi10.py /var/cmd/pi10.py
sudo cp pi20.py /var/cmd/pi20.py
sudo cp pi30.py /var/cmd/pi30.py
sudo cp pi40.py /var/cmd/pi40.py
sudo cp pi50.py /var/cmd/pi50.py
sudo cp pi60.py /var/cmd/pi60.py

# Make cmd service function as a service
sudo cp pi10.service /etc/systemd/system/pi10.service
sudo cp pi20.service /etc/systemd/system/pi20.service
sudo cp pi30.service /etc/systemd/system/pi30.service
sudo cp pi40.service /etc/systemd/system/pi40.service
sudo cp pi50.service /etc/systemd/system/pi50.service
sudo cp pi60.service /etc/systemd/system/pi60.service

# Enable and start services
sudo systemctl daemon-reload
sudo systemctl enable cmd.service
sudo systemctl restart cmd.service
sudo systemctl enable fake2.service
sudo systemctl restart fake2.service
sudo systemctl enable fake3.service
sudo systemctl restart fake3.service
sudo systemctl enable pi10.service
sudo systemctl restart pi10.service
sudo systemctl enable pi20.service
sudo systemctl restart pi20.service
sudo systemctl enable pi30.service
sudo systemctl restart pi30.service
sudo systemctl enable pi40.service
sudo systemctl restart pi40.service
sudo systemctl enable pi50.service
sudo systemctl restart pi50.service
sudo systemctl enable pi60.service
sudo systemctl restart pi60.service

# Delete command history
history -c
