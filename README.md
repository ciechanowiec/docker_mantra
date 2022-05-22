# Docker Mantra

## Description
The script in this repository (file `docker_install.sh`) setups Docker environment and:
1. installs the latest version of Docker
2. sets Docker to be run without `sudo` prefix
3. installs the latest version of Docker Compose
4. installs Docker Cleaner script (file `.clean_docker.sh`), which can:
   * delete all Docker containers including volumes in use
   * delete all Docker images
   * be run by as an alias `clean_docker`

## How to Use
1. Clone this repository
2. Give the script a permission to be run (`chmod 755 ~/docker_install.sh`)
3. Run the script with a command `sudo ~/docker_install.sh`
4. Reboot
