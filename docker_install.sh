#!/bin/bash

# ============================================== #
#                                                #
#                  DEFINITIONS                   #
#                                                #
# ============================================== #

# Prerequisites:
# - curl

scriptDir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null && pwd)
tempDir=~/.temp
currentDir=$(pwd)
boldRed="\e[1;91m"
boldBlue="\e[1;34m"
resetFormat="\e[0m"
errorMessage="${boldRed}ERROR OCCURRED${resetFormat}"

printProcessMessage () {
  message=$1
  printf "${boldBlue}${message}${resetFormat}\n"
}

printProcessMessage "Going to the temporary directory where\ninstallation will be performed ($tempDir)..."
if [ -d $tempDir ]
then
  cd "$tempDir" || { printf "${errorMessage}\n"; exit 1; }
else
  mkdir "$tempDir"
  cd "$tempDir" || { printf "${errorMessage}\n"; exit 1; }
fi

# ============================================== #
#                                                #
#                 DOCKER ENGINE                  #
#                                                #
# ============================================== #

# The installation process below is performed according to the following instructions:
# https://docs.docker.com/engine/install/ubuntu/

printProcessMessage "\nINSTALLING DOCKER ENGINE..."

printProcessMessage "Removing old Docker versions..."
sudo apt-get remove docker docker-engine docker.io containerd runc -y

printProcessMessage "Setting up the repository..."
sudo apt-get update -y
sudo apt-get install \
     ca-certificates \
     curl \
     gnupg \
     lsb-release
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo \ "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \ $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

printProcessMessage "Installing Docker Engine..."
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin

printProcessMessage "Running 'hello-world' Docker image to test installation..."
sudo docker run hello-world
exitCodeForDockerRun=$?

if [ "$exitCodeForDockerRun" -eq 0 ]
then
  printProcessMessage "Docker Engine successfully installed"
else
  printf "${errorMessage}\n"
  exit 1
fi

# ============================================== #
#                                                #
#                DOCKER COMPOSE                  #
#                                                #
# ============================================== #

# The installation process below is performed according to the following instructions:
# https://www.digitalocean.com/community/tutorials/how-to-install-and-use-docker-compose-on-ubuntu-20-04

printProcessMessage "\nINSTALLING DOCKER COMPOSE..."

printProcessMessage "\nRetrieving information about the latest Docker Compose version..."
# The code below:
# 1. Retrieves the source code of webpage about latest Docker Compose releases:
# https://github.com/docker/compose/releases
# 2. Extracts from the retrieved data a list of latest Docker Compose releases
# (those originally come from lines like <h1 data-view-component="true" class="d-inline mr-3"><a href="/docker/compose/releases/tag/v2.5.1" data-view-component="true" class="Link--primary">v2.5.1</a>)
# 3. Chooses the first line from the extracted list of latest Docker
# Compose releases, i.e. the latest Docker Compose release

latestDockerRelease=$(curl https://github.com/docker/compose/releases \
	| grep -oP '(?<=/docker/compose/releases/tag/).*(?=" data)' \
	| head -1)

printProcessMessage "Now the latest (${latestDockerRelease}) Docker Compose release will be downloaded and
    saved as executable file at /usr/local/bin/docker-compose, which
    will make this software globally accessible as docker-compose..."
sudo curl -L "https://github.com/docker/compose/releases/download/${latestDockerRelease}/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose

printProcessMessage "Setting the correct permissions so that the 'docker-compose' command is executable..."
sudo chmod +x /usr/local/bin/docker-compose

# ============================================== #
#                                                #
#                    CLEAN UP                    #
#                                                #
# ============================================== #

printProcessMessage "Going back to the working directory ($currentDir)..."
cd "$currentDir" || { printf "${errorMessage}\n"; exit 1; }
