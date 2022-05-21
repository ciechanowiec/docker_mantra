#!/bin/bash

# ============================================== #
#                                                #
#                  SCRIPT SETUP                  #
#                                                #
# ============================================== #

scriptDir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)
tempDir=~/.temp
currentDir=$(pwd)
boldRed="\e[1;91m"
boldBlue="\e[1;34m"
resetFormat="\e[0m"
cleanDockerScript="${scriptDir}/.clean_docker.sh"

printProcessMessage () {
  message=$1
  printf "${boldBlue}${message}${resetFormat}\n"
}

printCustomErrorAndExit () {
  errorMessageContent=$1
  errorMessage="${boldRed}${errorMessageContent}${resetFormat}\n"
  exitMessage="${boldRed}EXITING THE SCRIPT...${resetFormat}\n"
  printf "${errorMessage}"
  printf "${exitMessage}\n"
  exit 1
}

printInvalidDirErrorAndExit () {
  errorMessage="${boldRed}Error during directory manipulation occurred${resetFormat}"
  exitMessage="${boldRed}EXITING THE SCRIPT...${resetFormat}\n"
  printf "${errorMessage}"
  printf "${exitMessage}\n"
  exit 1
}

printProcessMessage "Going to the temporary directory where installation
    will be performed ($tempDir)..."
if [ -d $tempDir ]
then
  cd "$tempDir" || printInvalidDirErrorAndExit
else
  mkdir "$tempDir"
  cd "$tempDir" || printInvalidDirErrorAndExit
fi

# ============================================== #
#                                                #
#              CHECK PREREQUISITES               #
#                                                #
# ============================================== #

printProcessMessage "PREREQUISITES CHECK..."

if ! command curl --version &> /dev/null
then
		printCustomErrorAndExit "Error: 'curl' package isn't installed"
elif [ ! -f "${cleanDockerScript}" ]
then
    printCustomErrorAndExit "Error: '${cleanDockerScript}' file wasn't found"
fi

## ============================================== #
##                                                #
##                    DOCKER                      #
##                                                #
## ============================================== #
#
#printProcessMessage "\nINSTALLING DOCKER..."
#
#printProcessMessage "Removing old Docker versions..."
#sudo apt remove --purge docker docker-engine docker.io containerd runc -y
#sudo snap remove docker
#
#printProcessMessage "Installing Docker..."
#sudo snap install docker
#
#printProcessMessage "Initializing Docker..."
#sleep 7
#
#printProcessMessage "Setting Docker to be run without 'sudo' prefix..."
#sudo groupadd docker
#sudo usermod -aG docker $USER
#newgrp docker << EOF # This prevents the script from exiting after 'newgrp' command is executed
#echo The script now runs as group \$(id -gn)
#EOF
#
#printProcessMessage "Running 'hello-world' Docker image to test installation..."
#docker run hello-world
#exitCodeForDockerRun=$?
#
#if [ "$exitCodeForDockerRun" -eq 0 ]
#then
#  printProcessMessage "Docker successfully installed"
#else
#  printCustomErrorAndExit "Error during Docker installation occurred"
#fi
#
## ============================================== #
##                                                #
##                DOCKER COMPOSE                  #
##                                                #
## ============================================== #
#
## The installation process below is performed according to the following instructions:
## https://www.digitalocean.com/community/tutorials/how-to-install-and-use-docker-compose-on-ubuntu-20-04
#
#printProcessMessage "\nINSTALLING DOCKER COMPOSE..."
#
#printProcessMessage "Removing old Docker Compose versions..."
#sudo rm -rf /usr/local/bin/docker-compose
#
#printProcessMessage "Retrieving information about the latest Docker Compose version..."
## The code below:
## 1. Retrieves the source code of the webpage with latest Docker Compose releases:
## https://github.com/docker/compose/releases
## 2. Extracts from the retrieved data a list of latest Docker Compose releases
## (those originally come from lines like <h1 data-view-component="true" class="d-inline mr-3"><a href="/docker/compose/releases/tag/v2.5.1" data-view-component="true" class="Link--primary">v2.5.1</a>)
## 3. Chooses the first line from the extracted list of latest Docker
## Compose releases, i.e. the latest Docker Compose release
#latestDockerRelease=$(curl https://github.com/docker/compose/releases \
#	| grep -oP '(?<=/docker/compose/releases/tag/).*(?=" data)' \
#	| head -1)
#
#printProcessMessage "Now the latest (${latestDockerRelease}) Docker Compose release will be downloaded and
#    saved as executable file at /usr/local/bin/docker-compose, which
#    will make this software globally accessible as docker-compose..."
#sudo curl -L "https://github.com/docker/compose/releases/download/${latestDockerRelease}/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
#
#printProcessMessage "Setting the correct permissions so that the 'docker-compose' command is executable..."
#sudo chmod +x /usr/local/bin/docker-compose
#
#printProcessMessage "Checking Docker Compose installation..."
#actualDCVersion=$(docker-compose -v)
#if [[ "$actualDCVersion" == *"$latestDockerRelease"* ]]
#then
#  printProcessMessage "Docker Compose successfully installed"
#else
#  printCustomErrorAndExit "Error during Docker Compose installation occurred"
#fi

## ============================================== #
##                                                #
##                DOCKER CLEANER                  #
##                                                #
## ============================================== #

printProcessMessage "\nINSTALLING DOCKER CLEANER..."
cp "$cleanDockerScript" ~

# ============================================== #
#                                                #
#                    CLEAN UP                    #
#                                                #
# ============================================== #

printProcessMessage "\nCLEANING UP..."

printProcessMessage "Going back to the working directory ($currentDir)..."
cd "$currentDir" || exitBecauseInvalidDir
