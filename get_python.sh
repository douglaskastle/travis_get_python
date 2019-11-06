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

PYTHON_REV="3.7.4"
mkdir -p $TRAVIS_BUILD_DIR/local
mkdir -p $TRAVIS_BUILD_DIR/.venv
if [ ${machine} == "MsysNt" ]; then
    echo "It's Windows"
    ls $VENV_CACHE
    cd $TRAVIS_BUILD_DIR
    choco install python --version ${PYTHON_REV}
    py -m venv $TRAVIS_BUILD_DIR/.venv/Python-${PYTHON_REV}
    source $TRAVIS_BUILD_DIR/.venv/Python-${PYTHON_REV}/Scripts/activate
    py -m venv $VENV_CACHE/Python-${PYTHON_REV}
    ls $VENV_CACHE
    ls $VENV_CACHE/Python-${PYTHON_REV}/Scripts
else
    echo "It's other"
    if [ ${machine} == "Mac" ]; then
        brew update ; brew upgrade openssl
    else
        sudo apt-get install libssl-dev openssl
    fi
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
    source $TRAVIS_BUILD_DIR/.venv/Python-${PYTHON_REV}/bin/activate
fi
python -m pip install pip yolk3k --upgrade
python -m yolk -l
which python
