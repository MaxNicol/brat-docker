# start from a base ubuntu image
FROM ubuntu

# Allow env variables to be used during build
ARG BRAT_USERNAME
ARG BRAT_PASSWORD
ARG BRAT_EMAIL

ENV BRAT_USERNAME=$BRAT_USERNAME
ENV BRAT_PASSWORD=$BRAT_PASSWORD
ENV BRAT_EMAIL=$BRAT_EMAIL

RUN echo $BRAT_EMAIL

# Install pre-reqs
RUN apt-get update
RUN apt-get install -y curl vim sudo wget rsync
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y apache2
RUN apt-get install -y git
RUN apt-get install -y python
RUN apt-get install -y supervisor
RUN apt-get clean
RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Set working directory
WORKDIR /var/www/

# Fetch  brat
RUN git clone https://github.com/nlplab/brat.git
WORKDIR /var/www/brat

# Install brat
ADD brat_install_wrapper.sh /usr/bin/brat_install_wrapper.sh
RUN chmod +x /usr/bin/brat_install_wrapper.sh
RUN /usr/bin/brat_install_wrapper.sh

# Make sure apache can access it
RUN chown -R www-data:www-data /var/www/brat/

# Copy apache config to container
ADD 000-default.conf /etc/apache2/sites-available/000-default.conf

# Enable cgi
RUN a2enmod cgi

# We can't use apachectl as an entrypoint because it starts apache and then exits, taking your container with it.
# Instead, use supervisor to monitor the apache process
RUN mkdir -p /var/log/supervisor
ADD supervisord.conf /etc/supervisor/conf.d/supervisord.conf

CMD ["/usr/bin/supervisord"]





