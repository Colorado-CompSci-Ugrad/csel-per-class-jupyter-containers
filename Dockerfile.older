FROM gcr.io/csel-stage-161517/datascience-notebook
MAINTAINER CSEL Ops <admin@cs.colorado.edu>

#COPY    ./cling.bz2 /tmp

USER	root

ENV	PATH=/opt/cling/bin:$PATH

RUN	sudo apt-get update && \
	apt-get -y --no-install-recommends install apt-transport-https manpages openssh-client gdb && \
	apt-get autoremove && \
	apt-get autoclean

##
## for jupyterlab-monaco when we can use it
##
RUN	cd /tmp && \
	curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add - && \
	echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list && \
	sudo apt-get update && sudo apt-get install -y yarn

RUN	apt-get update && \
 	apt-get install apt-transport-https && \
 	echo "deb https://dl.bintray.com/sbt/debian /" | sudo tee -a /etc/apt/sources.list.d/sbt.list && \
 	apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 2EE0EA64E40A89B84B2DF73499E82A75642AC823 && \
	apt-get update && \
	DEBIAN_FRONTEND=noninteractive apt-get install -y sbt scala default-jdk mysql-client mysql-server

# install jupyter-scala
RUN 	curl -L -o coursier https://git.io/vgvpD && \
    	chmod +x coursier && \
     	mv coursier /usr/bin/ && \
	git clone https://github.com/jupyter-scala/jupyter-scala.git && \
        jupyter-scala/jupyter-scala --jupyter-path /opt/conda/share/jupyter && \
        rm -rf jupyter-scala && \
        /usr/local/bin/fix-permissions /opt && \
        /usr/local/bin/fix-permissions /home/jovyan

#RUN	cd /opt/cling/share/cling/Jupyter/kernel && \
#	$CONDA_DIR/bin/pip install -e . && \
#	$CONDA_DIR/bin/jupyter-kernelspec install cling-cpp11 

RUN	$CONDA_DIR/bin/pip install bash_kernel && \
	$CONDA_DIR/bin/python -m bash_kernel.install

#RUN	jupyter labextension install jupyterlab_voyager

RUN 	pip install jupyterlab_latex && \
	jupyter serverextension enable --sys-prefix jupyterlab_latex && \
	jupyter labextension install @jupyterlab/latex

ENV	NODE_OPTIONS=--max-old-space-size=4096

# RUN	cd /opt && \
# 	git clone https://github.com/jupyterlab/jupyterlab-monaco && \
# 	cd jupyterlab-monaco && \
# 	yarn install && \
# 	yarn run build && \
# 	jupyter labextension link .

RUN conda update -n base conda && \
    conda install bokeh plotly vega3 qgrid

# install beakerx
#RUN conda update -n base conda && \
#    conda install beakerx bokeh plotly vega3 qgrid && \
#    conda update -n base --all -y

#RUN beakerx install 
#RUN jupyter labextension install @jupyter-widgets/jupyterlab-manager
#RUN jupyter labextension install beakerx-jupyterlab 
#RUN jupyter labextension install @jupyterlab/geojson-extension

RUN	jupyter labextension install @jupyterlab/plotly-extension && \
	jupyter labextension install @jupyterlab/vega3-extension && \
	jupyter labextension install @jupyter-widgets/jupyterlab-manager && \
	jupyter labextension install @jupyterlab/hub-extension && \
	jupyter labextension install @jupyterlab/github && \
	jupyter labextension install jupyterlab_bokeh && \
	jupyter labextension install qgrid

RUN	pip install ipython-sql

RUN	jupyter lab build

RUN	apt-get update && \
	apt-get install -y build-essential libc6-dev-i386 man valgrind gcc-multilib g++-multilib \
		software-properties-common python-software-properties

RUN	add-apt-repository "deb https://cli-assets.heroku.com/branches/stable/apt ./" && \
	curl -L https://cli-assets.heroku.com/apt/release.key | sudo apt-key add - && \
	apt-get update && apt-get install heroku

RUN /usr/local/bin/fix-permissions /opt && \
    /usr/local/bin/fix-permissions /home/jovyan

USER	$NB_UID
