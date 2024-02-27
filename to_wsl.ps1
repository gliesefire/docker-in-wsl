# Run docker build to build the image
docker build -t docker_in_wsl .

# Export the image to a tar file
docker export $(docker create docker_in_wsl) --output="docker_in_wsl.tar"

# Import the tar file as a WSL distro
wsl --import docker_in_wsl .\docker_in_wsl docker_in_wsl.tar
