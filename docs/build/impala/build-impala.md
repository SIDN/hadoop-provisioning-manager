Build Impala on Ubuntu 20.04

see: https://cwiki.apache.org/confluence/display/IMPALA/Building+Impala

# Download

wget https://dlcdn.apache.org/impala/4.0.0/apache-impala-4.2.0.tar.gz
tar xvfz apache-impala-4.2.0.tar.gz
cd apache-impala-4.2.0

export IMPALA_HOME=`pwd`

# 1 time
./bin/bootstrap_system.sh
apt-get install python3.6
-- make py 3.6 default default
https://hackersandslackers.com/multiple-python-versions-ubuntu-20-04/

apt-get install python3.6-dev

# always
. ./bin/impala-config.sh


./buildall.sh -noclean -skiptests -notests  -release

# create package

./create-dist.py --version 4.2.0 --dist ubuntu \
cd dist \
tar cvfz  apache-impala-ubuntu-4.2.0.tar.gz apache-impala-ubuntu-4.2.0 \

scp apache-impala-ubuntu-4.2.0.tar.gz downloads.sidnlabs.nl:....

