FROM archlinux:latest
LABEL maintainer="Sepand KASHANI <sepand.kashani@epfl.ch>"
RUN pacman -Syu --noconfirm base-devel

# Create 'build' user with super-user capabilities. ============================
# Why do we do this? Because using commands such as `makepkg` directly as
# user=root is illegal.
ENV BUILD_USER build
ENV BUILD_USERDIR /home/build
ENV BUILD_USERID 1001

RUN useradd ${BUILD_USER} --create-home --uid ${BUILD_USERID}
RUN passwd --delete ${BUILD_USER}
RUN printf "${BUILD_USER} ALL=(ALL) NOPASSWD:ALL\n" | tee -a /etc/sudoers

# Install Software Tools =======================================================
WORKDIR /tmp
RUN pacman -Syu --needed --noconfirm \
           community/bat \
           community/detox \
           community/fzf \
           community/nano-syntax-highlighting \
           community/sshfs \
           community/tmux \
           core/gcc \
           core/nano \
           core/net-tools \
           extra/bash-completion \
           extra/cmake \
           extra/ethtool \
           extra/extra-cmake-modules \
           extra/git \
           extra/htop \
           extra/python \
           extra/rsync \
           extra/wget

USER ${BUILD_USER}
RUN git clone https://aur.archlinux.org/trizen.git && \
    cd trizen && \
    makepkg -si --noconfirm
RUN trizen -Syu --needed --noconfirm \
           aur/conan
USER root

RUN wget --quiet https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O miniconda.sh && \
    /bin/bash miniconda.sh -b -p /opt/conda && \
    /opt/conda/bin/conda clean -tipsy

# Prepare Environment for use ==================================================
WORKDIR /root
ADD  shell/.bash_aliases    .
RUN printf "export PATH="${PATH}":/opt/conda/bin" | tee -a ./.bash_aliases
RUN printf "if [ -f ~/.bash_aliases ]; then . ~/.bash_aliases; fi" | tee -a ./.bashrc
ADD  tmux/.tmux.conf        .
ADD  tmux/.tmux.conf.local  .
