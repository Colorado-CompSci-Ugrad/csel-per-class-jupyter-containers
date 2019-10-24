ARG BASE_CONTAINER=jupyter/datascience-notebook:1386e2046833
FROM $BASE_CONTAINER
LABEL MAINTAINER="CSEL Ops <admin@cs.colorado.edu>""

#############################################################################
## CU specific
#############################################################################

USER root

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && apt-get -yq dist-upgrade \
 && (echo y | DEBIAN_FRONTEND=noninteractive sh -x /usr/local/sbin/unminimize) \
 && apt-get install -yq --no-install-recommends \
    	     ca-certificates-java \
	         libgtest-dev cmake-curses-gui \
		 net-tools \
		openssh-client gdb \
		build-essential libc6-dev-i386 man valgrind gcc-multilib g++-multilib \
		software-properties-common python3-software-properties curl gnupg \
		mysql-client apt-transport-https psmisc graphviz vim ffmpeg \
		 fonts-dejavu \
		 gfortran \
		 googletest


RUN	$CONDA_DIR/bin/pip install bash_kernel && \
	$CONDA_DIR/bin/python -m bash_kernel.install

RUN 	$CONDA_DIR/bin/pip install jupyterlab_latex && \
	jupyter labextension install @jupyterlab/latex && \
	jupyter labextension install @mflevine/jupyterlab_html && \
	jupyter labextension install jupyterlab-drawio

#
# See https://github.com/jupyter/notebook/issues/4311 for specific issue with tornado
#        'tornado<6' \
# No longer an issue?
#
RUN    conda install --no-update-deps -c conda-forge \
       bokeh plotly vega3 qgrid pygraphviz \
	  	ipython-sql beakerx>1.3.0 mysqlclient && \
       jupyter labextension install beakerx-jupyterlab

RUN    conda install -c conda-forge xeus-cling \
       && $CONDA_DIR/bin/pip install nbgitpuller

RUN    jupyter labextension install @jupyterlab/git && \
       $CONDA_DIR/bin/pip install -U jupyterlab-git  &&\
       jupyter serverextension enable --py --sys-prefix jupyterlab_git

#
# Turtle graphics - not usable yet
#
#RUN	jupyter labextension install @jupyter-widgets/jupyterlab-manager && \
#	cd /opt && \
#	git clone https://github.com/dirkcgrunwald/mobilechelonian.git && \
#	cd mobilechelonian && \
#	python setup.py install 

RUN	curl https://cli-assets.heroku.com/install.sh | sh

RUN	conda install -c conda-forge python-language-server flake8 autopep8 \
	jupyter-server-proxy \
	python-language-server flake8 autopep8

RUN	$CONDA_DIR/bin/pip install -vvv git+git://github.com/jupyterhub/jupyter-server-proxy@master && \
	jupyter serverextension enable --py --sys-prefix jupyter_server_proxy

RUN	(cd /tmp && \
	git clone https://github.com/jupyterhub/jupyter-server-proxy && \
	cd /tmp/jupyter-server-proxy/jupyterlab-server-proxy && \
	npm install && npm run build && jupyter labextension link . )

#RUN	
#	jupyter labextension install jupyterlab-server-proxy

RUN	$CONDA_DIR/bin/pip  install --index-url https://test.pypi.org/simple/ --extra-index-url https://pypi.org/simple jupyter-codeserver-proxy==1.0b1

RUN	cd /opt && \
	mkdir /opt/code-server && \
	cd /opt/code-server && \
	wget -qO- https://github.com/cdr/code-server/releases/download/2.1523-vsc1.38.1/code-server2.1523-vsc1.38.1-linux-x86_64.tar.gz | tar zxvf - --strip-components=1
ENV	PATH=/opt/code-server:$PATH

##
## Geopython, XML
##
RUN	conda install -c conda-forge \
	conda-forge::gdal conda-forge:libgdal \
	conda-forge::lxml conda-forge::geopandas conda-forge::geoplot \
	conda-forge::folium conda-forge::pysal conda-forge::esda conda-forge::rasterio conda-forge::poppler \
	conda-forge::psycopg2 \
	&& \
	apt-get update && \
	apt-get install -yq --no-install-recommends xqilla libxqilla-dev && \
	rm -rf /var/lib/apt/lists/* && \
	$CONDA_DIR/bin/pip install contextily libpysal mgwr mapclassify esda python-simplexquery pymysql

##
## Perf, MPICH
## You need to enable CAP_SYS_ADMIN to use perf in Docker
## For more infomration, refer to https://blog.alicegoldfuss.com/enabling-perf-in-kubernetes/
RUN  apt-get update && \
     apt-get install -yq --no-install-recommends linux-tools-generic mpich libmpich-dev hwloc && \
     cd /usr/lib/linux-tools && \
     find `pwd` -name perf | xargs -I org_perf ln -s org_perf /usr/local/bin/perf && \
     rm -rf /var/lib/apt/lists/*


#
# Declutter

RUN	echo "y" | /opt/conda/bin/jupyter-kernelspec remove -y \
	clojure groovy kotlin xcpp14

ENV	PATH=/opt/theia/node_modules/.bin:$PATH

COPY	before-notebook.d /usr/local/bin/before-notebook.d
COPY	start-notebook.d /usr/local/bin/start-notebook.d

RUN	rm -rf /home/jovyan  && \
	mkdir /home/jovyan && \
	chown $NB_UID:$NB_GID /home/jovyan && \
	rm -rf /usr/local/bin/fix-permissions

USER	$NB_UID
