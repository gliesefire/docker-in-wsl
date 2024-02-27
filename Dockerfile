FROM debian:latest

# Execute the script
COPY install_docker.sh ./install_docker.sh
RUN ./install_docker.sh
