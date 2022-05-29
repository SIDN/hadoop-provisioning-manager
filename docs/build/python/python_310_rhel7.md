
# Build Python 3.10.4

RHEL 7.9 has only support for older Python versions.
compile Python 3.10 and create package using these steps on build server:

see: https://www.workaround.cz/howto-build-compile-install-latest-python-310-39-38-37-centos-7-8-9/#Step_3_compile_Python_source_code_into_binaries

# Get deps

sudo yum -y install wget yum-utils gcc openssl-devel bzip2-devel libffi-devel


# Get source

wget https://www.python.org/ftp/python/3.10.4/Python-3.10.4.tgz
extract 

# need >= openssl 1.1.1

download, compile and install openssl 1.1.1
see: https://techglimpse.com/install-python-openssl-support-tutorial/

# GCC

make sure to use a newer gcc version (we already compiled gcc 7.5.0) otherwise build will fail.

export LD_LIBRARY_PATH=/build/gcc-native-7.5.0/lib64:$LD_LIBRARY_PATH
export PATH=/build/gcc-native-7.5.0/bin:$PATH

## do build

sudo ./configure --prefix=/opt/python-3.10 --enable-optimizations --with-system-ffi --with-computed-gotos --enable-loadable-sqlite-extensions
sudo make -j "$(nproc)"
sudo make altinstall

## create package

cd /opt/
tar cvfz /www/rel/python-3.10-rhel79.tar.gz ./python-3.10