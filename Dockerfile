FROM ppodgorsek/robot-framework:latest

MAINTAINER UltimateDogg
LABEL Base Robot Framework in Docker container. Based off of https://github.com/ppodgorsek/docker-robot-framework meant as a base image

# Install Packages not installed by base image
RUN dnf install -y \
		python2-crypto-2.6.1* \
		python2-devel-2.7.15* \
		git \
 	&& dnf clean all

#install all the robot framework libraries and needed libraries beyond what is installed by the base image
RUN pip install --upgrade pip setuptools \ 
	&& pip install --no-cache-dir \
	'robotframework-sshlibrary==3.3.0 ' \
	'robotframework-databaselibrary==1.2 ' \
	'robotframework-angularjs==0.0.9 '  \
	'robotframework-sudslibrary==0.8' \
	'robotframework-ftplibrary==1.6' \
	'robotframework-rammbock==0.4.0.1' \
	'robotframework-httplibrary==0.4.2' \
	'robotframework-archivelibrary==0.4.0' \
	'pycrypto==2.6.1' \
	'deepdiff==3.3.0' \
 	'dnspython==1.16.0' \
 	'PyYAML==5.1'

# fix for error of chrome hanging. This may not be needed anymore but doesnt seem to have ill effects
RUN echo "DBUS_SESSION_BUS_ADDRESS=/dev/null" >> /etc/environment

#copy our run script to the proper directory
COPY run.sh /opt/robotframework/bin/run.sh
RUN chmod +x /opt/robotframework/bin/run.sh

# set this script as our entrypoint
ENTRYPOINT ["/opt/robotframework/bin/run.sh"]