FROM ubuntu:18.04

# Install required packages
RUN 	apt-get update && \
    	apt-get install -y \
    	wget \
    	libgfortran4

# Create new user
RUN 	useradd -ms /bin/bash user
USER user
ENV 	HOME /home/user

# Download and install miniconda and pyfmi
RUN 	cd $HOME && \
	wget https://repo.anaconda.com/miniconda/Miniconda3-py310_23.1.0-1-Linux-x86_64.sh -O $HOME/miniconda.sh && \
	/bin/bash $HOME/miniconda.sh -b -p $HOME/miniconda && \
	. miniconda/bin/activate && \
	conda update -n base -c defaults conda && \
	conda create --name pyfmi3 python=3.10 -y && \
	conda activate pyfmi3 && \
	conda install -c conda-forge pyfmi=2.10.2 -y && \
	pip install flask-restful==0.3.9 && \
	conda install pandas==1.5.3 flask_cors==3.0.10 matplotlib==3.7.1 requests==2.28.1

WORKDIR $HOME

RUN mkdir models && \
    mkdir doc

ENV PYTHONPATH $PYTHONPATH:$HOME
ENV BOPTEST_DASHBOARD_SERVER https://api.boptest.net:8081/

CMD . miniconda/bin/activate && conda activate pyfmi3 && python restapi.py && bash

EXPOSE 5000
