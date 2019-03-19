unameOut="$(uname -s)"
case "${unameOut}" in
    Linux*)     machine=Linux;;
    Darwin*)    machine=Mac;;
    CYGWIN*)    machine=Cygwin;;
    MINGW*)     machine=MinGw;;
    MSYS_NT*)   machine=MsysNt;;
    *)          machine="UNKNOWN:${unameOut}"
esac
echo ${machine}

PYTHON_REV="3.7.2"
#PYTHON_REV="3.6.8"
mkdir -p $TRAVIS_BUILD_DIR/local
mkdir -p $TRAVIS_BUILD_DIR/.venv
if [ ${machine} == "MsysNt" ]; then
    echo "It's Windows"
    cd $TRAVIS_BUILD_DIR
    #mkdir Python-${PYTHON_REV}
    #cd Python-${PYTHON_REV}
    choco install python --version ${PYTHON_REV}
    py -m venv $TRAVIS_BUILD_DIR/.venv/Python-${PYTHON_REV}
    source $TRAVIS_BUILD_DIR/.venv/Python-${PYTHON_REV}/Scripts/activate
    python -m pip install pip yolk3k --upgrade
    python -m yolk -l
    
    which python
    python --version
else
    echo "It other"
    cd $TRAVIS_BUILD_DIR
    git clone https://github.com/openssl/openssl.git
    cd openssl
    ./config --prefix=$TRAVIS_BUILD_DIR/local/ssl --openssldir=$TRAVIS_BUILD_DIR/local/ssl
    make
    cd $TRAVIS_BUILD_DIR
    wget https://www.python.org/ftp/python/${PYTHON_REV}/Python-${PYTHON_REV}.tgz
    tar -zxvf Python-${PYTHON_REV}.tgz
    cd Python-${PYTHON_REV}
    ./configure --prefix=$TRAVIS_BUILD_DIR/local/Python-${PYTHON_REV}
    make
    ls
    if [ ${machine} == "Mac" ]; then
        ./python.exe -m venv $TRAVIS_BUILD_DIR/.venv/Python-${PYTHON_REV}
    else
        ./python -m venv $TRAVIS_BUILD_DIR/.venv/Python-${PYTHON_REV}
    fi
    ls $TRAVIS_BUILD_DIR/.venv/Python-${PYTHON_REV}/bin/
    source $TRAVIS_BUILD_DIR/.venv/Python-${PYTHON_REV}/bin/activate
    which python
    pip install --upgrade pip yolk3k
    yolk -l
fi
