# Pull base image.
FROM ubuntu:22.04

# Install.
RUN  apt-get update && apt-get install sudo -y && \
  adduser --disabled-password --gecos 'chale' chale


COPY ../install.sh /home/chale

RUN /bin/sh /home/chale/install.sh

COPY ../.tmux.conf /home/chale

COPY ../nvim /home/chale/.config/nvim

# Define working directory.
WORKDIR /home/chale

# Define default command.
CMD ["bash"]
