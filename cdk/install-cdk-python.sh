#!/bin/bash
## As per: https://docs.aws.amazon.com/cdk/latest/guide/getting_started.html
##
## Prerequisites: AWS CLI installed and configured, 
##
## See: https://aws.amazon.com/blogs/developer/getting-started-with-the-aws-cloud-development-kit-and-python/ for more details

YELLOW="\033[1;33m"
GREEN="\033[1;32m"
RED="\033[0;31m"
NOCOLOUR="\033[0m"

echo "Determining OS Type..."
string=$(uname)
if [[ $string =~ "Linux" ]]; then
    . /etc/os-release
    echo -e "${YELLOW}This is a Linux system running" $NAME $VERSION_ID "${NOCOLOUR}"

    # Ubuntu/Debian
    if [[ $NAME == *"Ubuntu"* ]] || [[ $NAME == *"Debian"* ]]; then   
        echo -e "${GREEN}Updating package lists...${NOCOLOUR}"
        sudo apt-get update
        echo -e "${GREEN}Installing Python3 and Python3-venv...${NOCOLOUR}"
        sudo apt-get install -y python3 python3-venv
        echo -e "${GREEN}Checking to see if NodeJS is installed...${NOCOLOUR}"
        node -v
        if [[ $? != 0 ]]; then
            echo -e "${GREEN}Installing NodeJS...${NOCOLOUR}"
            curl -sL https://deb.nodesource.com/setup_15.x | sudo -E bash -
            sudo apt-get install -y nodejs
        fi
    # CentOS/Fedora
    elif [[ $NAME == *"CentOS"* ]] || [[ $NAME == *"Fedora"* ]]; then
        sudo yum install epel-release -y
        echo -e "${GREEN}Installing Python3 and Python3-venv...${NOCOLOUR}"
        sudo yum install python3 python3-pip python3-virtualenv -y
        echo -e "${GREEN}Checking to see if NodeJS is installed...${NOCOLOUR}"
        node -v
        if [[ $? != 0 ]]; then
            echo -e "${GREEN}Installing NodeJS...${NOCOLOUR}"
            sudo yum install nodejs -y
        fi
    fi
#MacOS
elif [[ $string == *"Darwin"* ]]; then
        echo -e "${YELLOW}This system is running MacOS${NOCOLOUR}"
        echo -e "${GREEN}Checking to see if NodeJS is installed...${NOCOLOUR}"
        node -v
        if [[ $? != 0 ]]; then
            brew -v
            if [[ $? == 0 ]]; then
                echo -e "${GREEN}Installing NodeJS using Homebrew...${NOCOLOUR}"
                brew install node
            else
                echo -e "${GREEN}Installing NodeJS from the web...${NOCOLOUR}"
                curl "https://nodejs.org/dist/latest/node-${VERSION:-$(wget -qO- https://nodejs.org/dist/latest/ | sed -nE 's|.*>node-(.*)\.pkg</a>.*|\1|p')}.pkg" > "$HOME/Downloads/node-latest.pkg" && sudo installer -store -pkg "$HOME/Downloads/node-latest.pkg" -target "/"
            fi
        fi
else
    echo "\n${RED}Unable to detect OS Version. Terminating${RED}\n"
    exit 1
fi

# Install CDK Toolkit
echo -e "\n${GREEN}Installing CDK...${NOCOLOUR}"
sudo npm install -g aws-cdk
RES=$?

if [[ $RES == 254 ]]; then
    echo -e "${GREEN}AWS CDK Is already installed but errors returned. Fixing errors...${NOCOLOUR}"   
    sudo npm uninstall -g -S aws-cdk
    sudo npm install -g aws-cdk
elif [[ $RES != 0 ]]; then
    echo -e "${RED}Failed to install AWS CDK. Exiting.${NOCOLOUR}"
    exit 1
fi

echo -e "${GREEN}CDK Version:" 
cdk --version
echo -e $NOCOLOUR

echo -e "${GREEN}Installing python modules from requirements.txt...${NOCOLOUR}"
python3 -m pip install --upgrade -q -r requirements.txt

echo -e "\n${GREEN}Done.${NOCOLOUR}\n"