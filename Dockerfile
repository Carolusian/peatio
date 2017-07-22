FROM ruby:2.2.1
RUN apt-get update -qq && apt-get install -y build-essential \ 
            git-core curl zlib1g-dev libssl-dev libreadline-dev \ 
            libyaml-dev libsqlite3-dev sqlite3 libxml2-dev \ 
            libxslt1-dev libcurl4-openssl-dev \ 
            libffi-dev libpq-dev nodejs imagemagick
RUN DEBIAN_FRONTEND=noninteractive apt-get -y dist-upgrade
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install python-software-properties
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install software-properties-common

RUN echo "gem: --no-ri --no-rdoc" > ~/.gemrc

# Use /peatio as application path
RUN mkdir /peatio
WORKDIR /peatio

# Install required gems
ADD Gemfile /peatio/Gemfile
Add Gemfile.lock /peatio/Gemfile.lock
RUN bundle install 

# Add application files 
Add . /peatio

# Install Redis and RabbitMQ
RUN apt-get install -y redis-server rabbitmq-server
RUN rabbitmq-plugins enable rabbitmq_management

# Install PhantomJS
RUN apt-get install chrpath libxft-dev libfontconfig1-dev -y
RUN apt-get install libfreetype6 libfreetype6-dev -y
RUN apt-get install libfontconfig1 libfontconfig1-dev -y

# RUN apt-get install -y wget
# RUN cd ~
# ARG PHANTOM_JS="phantomjs-1.9.8-linux-x86_64"
# RUN wget https://bitbucket.org/ariya/phantomjs/downloads/$PHANTOM_JS.tar.bz2
# RUN mv $PHANTOM_JS.tar.bz2 /usr/local/share/
# RUN cd /usr/local/share/
# RUN tar xvjf $PHANTOM_JS.tar.bz2
# RUN ln -sf /usr/local/share/$PHANTOM_JS/bin/phantomjs /usr/local/share/phantomjs
# RUN ln -sf /usr/local/share/$PHANTOM_JS/bin/phantomjs /usr/local/bin/phantomjs
# RUN ln -sf /usr/local/share/$PHANTOM_JS/bin/phantomjs /usr/bin/phantomjs

# Add entrypoint file
COPY docker-entrypoint.sh /usr/local/bin
RUN ln -s /usr/local/bin/docker-entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
EXPOSE 3306
