FROM ubuntu:18.04

RUN curl -sL https://nvidia.github.io/nvidia-docker/gpgkey | apt-key add -
RUN distribution=$(. /etc/os-release;echo $ID$VERSION_ID) && \
    curl -sL https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | tee /etc/apt/sources.list.d/nvidia-docker.list

RUN DEBIAN_FRONTEND=noninteractive && \
	apt-get update && \
	apt-get install -y \
		gcc g++ gfortran \
		libc++-dev \
		libstdc++-6-dev zlib1g-dev \
		automake autoconf libtool \
		git subversion \
		libatlas3-base \
		nvidia-cuda-dev \
		ffmpeg \
		python3 python3-dev python3-pip \
		python python-dev python-pip \
		wget unzip && \
		apt-get upgrade -y && \
	apt-get clean

ADD ext /gentle/ext
RUN export MAKEFLAGS=' -j8' &&  cd /gentle/ext && \
	./install_kaldi.sh && \
	make depend && make && rm -rf kaldi *.o

ADD . /gentle
RUN cd /gentle && python3 setup.py develop
RUN cd /gentle && ./install_models.sh

EXPOSE 8765

VOLUME /gentle/webdata

CMD cd /gentle && python3 serve.py
