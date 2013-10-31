from ubuntu
maintainer Tobias Gesellchen <tobias@gesellix.de>

# basic setup
run cd /bin && rm sh && ln -s bash sh
run touch ~/.bashrc
run echo 'deb http://archive.ubuntu.com/ubuntu precise main universe' > /etc/apt/sources.list
run apt-get update
run apt-get upgrade -y
run apt-get install -y -q git curl wget

# install CouchDB
run apt-get install -y make gcc build-essential
run apt-get install -y erlang libmozjs-dev libicu-dev libcurl4-gnutls-dev libtool
run cd /tmp && wget http://apache.mirror.digionline.de/couchdb/source/1.4.0/apache-couchdb-1.4.0.tar.gz
run cd /tmp && tar xfz apache-couchdb-1.4.0.tar.gz
run cd /tmp/apache-couchdb-1.4.0 && ./configure && make && make install
run printf "[httpd]\nport = 8101\nbind_address = 0.0.0.0" > /usr/local/etc/couchdb/local.d/docker.ini

# install Java 7
run apt-get install software-properties-common python-software-properties -y
run apt-add-repository ppa:webupd8team/java -y
run apt-get update
run echo oracle-java7-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections
run apt-get install -y oracle-java7-installer

# install Elasticsearch
run cd /tmp && wget https://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-0.90.3.tar.gz
run cd /tmp && tar xfz elasticsearch-0.90.3.tar.gz
run mv /tmp/elasticsearch-0.90.3 /

# install nvm (npm/nodejs)
run cd ~ && curl https://raw.github.com/creationix/nvm/master/install.sh | sh
run cd ~ && . .nvm/nvm.sh && nvm install 0.11 && nvm use 0.11
run /bin/bash -c 'echo ". .nvm/nvm.sh && nvm use 0.11"' >> /.bashrc

run /bin/bash -c 'echo "/usr/local/bin/couchdb"' >> /.bashrc
run /bin/bash -c 'echo "/elasticsearch-0.90.3/bin/elasticsearch"' >> /.bashrc
expose :8101
expose :9200
expose :9300

cmd ["/bin/bash"]

# docker build -t="gesellix/stuff" .
# docker run -i -t gesellix/stuff