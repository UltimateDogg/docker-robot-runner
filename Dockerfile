FROM ppodgorsek/robot-framework:latest

MAINTAINER UltimateDogg
LABEL Base Robot Framework in Docker container. Extension of ppodgorsek/robot-framework to add a few packages

# Install Packages not installed by base image
RUN dnf install -y \
		python3-devel-3.7.3* \
		git \
 	&& dnf clean all

#install all the robot framework libraries and needed libraries beyond what is installed by the base image
RUN pip3 install --no-cache-dir \
	'robotframework-angularjs==0.0.9 '  \
	'robotframework-archivelibrary==0.4.0'

#copy our run script to the proper directory
COPY run.sh /opt/robotframework/bin/run.sh
RUN chmod +x /opt/robotframework/bin/run.sh

# set this script as our entrypoint
ENTRYPOINT ["/opt/robotframework/bin/run.sh"]