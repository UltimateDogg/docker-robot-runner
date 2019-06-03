FROM ppodgorsek/robot-framework:3.3.1

MAINTAINER UltimateDogg
LABEL Base Robot Framework in Docker container. Extension of ppodgorsek/robot-framework to add a few packages

# Install Packages not installed by base image
RUN dnf install -y \
		python2-crypto-2.6.1* \
		python2-devel-2.7.16* \
		git \
 	&& dnf clean all

#install all the robot framework libraries and needed libraries beyond what is installed by the base image
RUN pip install --no-cache-dir \
	'robotframework-angularjs==0.0.9 '  \
	'robotframework-archivelibrary==0.4.0' \
	'robotframework-pykafka==0.10' \
	'pycrypto==2.6.1' \
 	'PyYAML==5.1'

#copy our run script to the proper directory
COPY run.sh /opt/robotframework/bin/run.sh
RUN chmod +x /opt/robotframework/bin/run.sh

# set this script as our entrypoint
ENTRYPOINT ["/opt/robotframework/bin/run.sh"]