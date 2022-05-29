
see: https://cwiki.apache.org/confluence/display/IMPALA/Building+Impala

build steps:

mkdir -p /www/rel 
yum -y install nginx 
cp download-site-nginx.conf /etc/nginx/nginx.conf
systemctl restart nginx

sudo setsebool -P httpd_can_network_connect on
chcon -Rt httpd_sys_content_t /www

yum install maven

wget https://dlcdn.apache.org/impala/4.0.0/apache-impala-4.0.0.tar.gz
tar xvfz apache-impala-4.0.0.tar.gz
cd apache-impala-4.0.0
export IMPALA_HOME=`pwd`
./bin/bootstrap_system.sh

. ./bin/impala-config.sh
./buildall.sh -noclean -skiptests -notests  -release

./create-dist.py --version 4.0.0 --dist rhel79 \
cd dist \
tar cvfz  apache-impala-4.0.0.tar.gz apache-impala-4.0.0 \
cp apache-impala-4.0.0.tar.gz /www/rel/ \
cd toolchain/cdp_components-11920537 \
tar cvfz /www/rel/apache-hive-3.1.3000.7.2.9.0-146-bin.tar.gz apache-hive-3.1.3000.7.2.9.0-146-bin


see also: https://stackoverflow.com/questions/47524150/building-apache-impala-fails

# for rhel7 need newer gcc 7.5.0

create native gcc 7.5.0
see: https://gcc.gnu.org/install/

 yum install gmp-devel
yum install mpfr-devel
yum install libmpc-devel

/build/gcc-7.5.0/configure --host=x86_64-pc-linux-gnu --prefix=/build/gcc-native-7.5.0 --disable-multilib \
--enable-languages=c,c++ 

make bootstrap-lean
make install-strip

tar cvfz gcc-native-7.5.0-rhel79.tar.gz gcc-native-7.5.0
cp /build/gcc-native-7.5.0-rhel79.tar.gz /www/rel/

