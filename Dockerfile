FROM fedora:26

MAINTAINER UltimateDogg
LABEL Base Robot Framework in Docker container. Based off of https://github.com/ppodgorsek/docker-robot-framework meant as a base image

# Copy our setup script to the proper directory
COPY setup.sh /setup.sh

# Give it the right permissions and run it
RUN chmod +x /setup.sh && \
	/setup.sh && \
	rm /setup.sh

# Install geckodriver from github
RUN wget https://github.com/mozilla/geckodriver/releases/download/v0.18.0/geckodriver-v0.18.0-linux64.tar.gz && \
	tar xfz geckodriver-v0.18.0-linux64.tar.gz && \
	mkdir -p /opt/robot/drivers && \
	cp geckodriver /opt/robot/drivers && \
	chmod +x /opt/robot/drivers/geckodriver && \
	rm geckodriver-v0.18.0-linux64.tar.gz

# Add the chrome startup scripts
RUN wget https://raw.githubusercontent.com/ppodgorsek/docker-robot-framework/3.0.5/bin/chromedriver.sh -O chromedriver && \
	wget https://raw.githubusercontent.com/ppodgorsek/docker-robot-framework/3.0.5/bin/chromium-browser.sh -O chromium-browser && \
	mkdir -p /opt/robot/bin && \
	cp chromedriver /opt/robot/bin && \
	cp chromium-browser /opt/robot/bin && \
	chmod +x /opt/robot/bin/chromedriver && \
	chmod +x /opt/robot/bin/chromium-browser && \
	rm chromedriver && \
	rm chromium-browser

# FIXME: below is a workaround, as the path is ignored
RUN mv /usr/lib64/chromium-browser/chromium-browser /usr/lib64/chromium-browser/chromium-browser-original\
	&& ln -sfv /opt/robot/bin/chromium-browser /usr/lib64/chromium-browser/chromium-browser

# add the bin and drivers directory we added stuff to the path
ENV PATH=/opt/robot/bin:/opt/robot/drivers:$PATH

# fix for error of chrome hanging. This may not be needed anymore but doesnt seem to have ill effects
RUN echo "DBUS_SESSION_BUS_ADDRESS=/dev/null" >> /etc/environment

#the reports are still a volume for now
VOLUME /opt/robot/reports

#copy our run script to the proper directory
ADD run.sh /opt/robot/run.sh
RUN chmod +x /opt/robot/run.sh
RUN cd /opt/robot/

# set this script as our entrypoint
ENTRYPOINT ["/opt/robot/run.sh"]