FROM ubuntu:22.04

RUN DEBIAN_FRONTEND=noninteractive && \
	apt-get update && \
	apt-get install -y \
		gcc g++ gfortran \
		libc++-dev \
		libstdc++-9-dev zlib1g-dev \
		automake autoconf libtool \
		git subversion \
		libatlas3-base \
		nvidia-cuda-dev \
		ffmpeg \
		python3 python3-dev python3-pip \
		python2 python2-dev \
		wget unzip && \
	apt-get clean

RUN ln -s /usr/bin/python2 /usr/bin/python
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