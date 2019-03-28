#!/bin/bash
#
# setup : script to do basic setup required for runtime environment. This script can be run again to update anything but only works on linux
# this should stay in the docker build only

# Install Python Pip, firefox, Robot framework, wget, etc
dnf upgrade -y
dnf install -y \
		chromedriver-63.0.3239.108-1.fc26 \
		chromium-63.0.3239.108-1.fc26 \
		firefox-60.0-4.fc26 \
		python2-crypto-2.6.1-14.fc26 \
		python2-devel-2.7.15-1.fc26 \
		python2-pip-9.0.1-9.fc26 \
		xorg-x11-server-Xvfb-1.19.3-4.fc26 \
		which-2.21-2.fc26 \
		git \
		wget
dnf clean all

# show python version
python --version

# first upgrade pip
pip install --upgrade pip

#install all the robot framework libraries and needed libraries
pip install --no-cache-dir \
	'robotframework==3.0.4' \
	'robotframework-selenium2library==1.8.0' \
	'robotframework-requests==0.5.0' \
	'robotframework-sshlibrary==2.1.3' \
	'robotframework-databaselibrary==1.1.1' \
	'robotframework-extendedselenium2library==0.9.1'  \
	'robotframework-sudslibrary==0.8' \
	'robotframework-ftplibrary==1.3' \
	'robotframework-rammbock==0.4.0.1' \
	'robotframework-httplibrary==0.4.2' \
	'robotframework-archivelibrary==0.3.2' \
	'robotframework-pabot==0.45 ' \
	'pycrypto==2.6.1' \
	'selenium<=3.0.0' \
	'requests==2.11.1' \
	'deepdiff==2.5.1' \
 	'dnspython==1.15.0' \
 	'PyYAML==3.12'