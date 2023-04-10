FROM ubuntu:18.04

# RUN apt-get update && apt-get install -y \
#     curl gnupg

# Add the NVIDIA repository key
RUN apt-get update && apt-get install -y gnupg ca-certificates && \
    apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/7fa2af80.pub

# Add the NVIDIA repository to the system
RUN echo "deb https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/ /" | tee /etc/apt/sources.list.d/cuda.list

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
