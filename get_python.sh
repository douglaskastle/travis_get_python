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

PYTHON_VENV="${VENV_CACHE}/${machine}/Python-${PYTHON_REV}"
mkdir -p "${VENV_CACHE}/${machine}"

if [ ${machine} == "MsysNt" ]; then
    echo "It's Windows"
    choco install python --version ${PYTHON_REV}
    py -m venv ${PYTHON_VENV}
else
    if [ ! -d "${PYTHON_VENV}" ]; then
        echo "False"
        cd $TRAVIS_BUILD_DIR
        echo "It's other"
        if [ ${machine} == "Mac" ]; then
            #brew update
            brew upgrade openssl
        else
            sudo apt-get install libssl-dev openssl
        fi
        wget https://www.python.org/ftp/python/${PYTHON_REV}/Python-${PYTHON_REV}.tgz
        tar -zxvf Python-${PYTHON_REV}.tgz > logfile 2>&1
        cd Python-${PYTHON_REV}
        if [ ${machine} == "Mac" ]; then
            ./configure
            make
            ./python.exe -m venv ${PYTHON_VENV}
        else
            ./configure  > logfile 2>&1
            make  > logfile 2>&1
            ./python -m venv ${PYTHON_VENV}
        fi
    else
        echo "True"
    fi
fi

if [ ${machine} == "MsysNt" ]; then
    ls ${PYTHON_VENV}/Scripts
    source ${PYTHON_VENV}/Scripts/activate
else
    ls ${PYTHON_VENV}/activate
    source ${PYTHON_VENV}/bin/activate
fi

python -m pip install pip yolk3k --upgrade
python -m yolk -l
which python
ls $VENV_CACHE
