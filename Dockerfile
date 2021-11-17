# start from a base ubuntu image
FROM ubuntu

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
RUN apt-get install -y python
RUN apt-get install -y supervisor
RUN apt-get clean
RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Fetch  brat
RUN mkdir /var/www/brat
RUN curl -L https://github.com/nlplab/brat/archive/refs/tags/v1.3_Crunchy_Frog.tar.gz > /var/www/brat/brat-1.3_Crunchy_Frog.tar.gz
RUN cd /var/www/brat && tar -xvzf brat-1.3_Crunchy_Frog.tar.gz

# Install brat
ADD brat_install_wrapper.sh /usr/bin/brat_install_wrapper.sh
RUN chmod +x /usr/bin/brat_install_wrapper.sh
RUN ./usr/bin/brat_install_wrapper.sh

# Make sure apache can access it
RUN chown -R www-data:www-data /var/www/brat/brat-1.3_Crunchy_Frog/

## create a symlink so users can mount their data volume at /bratdata rather than the full path
RUN ln -s /var/www/brat/brat-1.3_Crunchy_Frog/data /bratdata
RUN mkdir /bratcfg
RUN ln -s /var/www/brat/brat-1.3_Crunchy_Frog/config.py /bratcfg/config.py

ADD 000-default.conf /etc/apache2/sites-available/000-default.conf

# Enable cgi
RUN a2enmod cgi

EXPOSE 80

# We can't use apachectl as an entrypoint because it starts apache and then exits, taking your container with it. 
# Instead, use supervisor to monitor the apache process
RUN mkdir -p /var/log/supervisor

ADD supervisord.conf /etc/supervisor/conf.d/supervisord.conf 

CMD ["/usr/bin/supervisord"]





