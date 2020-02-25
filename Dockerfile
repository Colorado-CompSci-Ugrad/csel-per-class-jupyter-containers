ARG BASE_CONTAINER=jupyter/datascience-notebook:1386e2046833
FROM $BASE_CONTAINER
LABEL MAINTAINER="CSEL Ops <admin@cs.colorado.edu>"

#############################################################################
## CU specific
#############################################################################

USER root

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get install -yq --no-install-recommends \
    				   ubuntu-minimal ubuntu-standard \
				   ca-certificates-java \
				   libgtest-dev cmake-curses-gui \
				   net-tools \
				   openssh-client gdb \
				   build-essential libc6-dev-i386 man \
				   valgrind gcc-multilib g++-multilib \
				   software-properties-common python3-software-properties curl gnupg \
		mysql-client apt-transport-https psmisc graphviz vim ffmpeg \
		 fonts-dejavu \
		 gfortran \
		 googletest libopencv-dev clang-9 lldb-9 && \
	rm -rf /var/lib/apt/lists/*


RUN	$CONDA_DIR/bin/pip install nbgitpuller

RUN    jupyter labextension install  --no-build @jupyterlab/git && \
       $CONDA_DIR/bin/pip install -U jupyterlab-git  &&\
       jupyter serverextension enable --py --sys-prefix jupyterlab_git

RUN 	$CONDA_DIR/bin/pip install jupyterlab_latex && \
	conda clean -afy && \
	jupyter labextension install --no-build @jupyterlab/latex && \
	jupyter labextension install --no-build  @mflevine/jupyterlab_html && \
	jupyter labextension install --no-build jupyterlab-drawio

RUN	curl https://cli-assets.heroku.com/install.sh | sh

RUN     conda install -c conda-forge --freeze-installed \
              python-language-server flake8 autopep8 \
	      altair vega_datasets \
	      bokeh datashader holoviews \
	      xeus-cling \
              jupyter-server-proxy && \
	jupyter labextension install --no-build @bokeh/jupyter_bokeh && \
        $CONDA_DIR/bin/pip install -vvv git+git://github.com/jupyterhub/jupyter-server-proxy@master && \
        jupyter serverextension enable --py --sys-prefix jupyter_server_proxy && \
	echo "y" | /opt/conda/bin/jupyter-kernelspec remove -y xcpp11 xcpp14 && \
        conda clean -afy


RUN     (cd /tmp && \
        git clone https://github.com/jupyterhub/jupyter-server-proxy && \
        cd /tmp/jupyter-server-proxy/jupyterlab-server-proxy && \
        npm install && npm run build && jupyter labextension link . && \
	rm -rf /tmp/jupyter-server-proxy )

RUN	cd /opt && \
	mkdir /opt/code-server && \
	cd /opt/code-server && \
	wget -qO- https://github.com/cdr/code-server/releases/download/2.1698/code-server2.1698-vsc1.41.1-linux-x86_64.tar.gz | tar zxvf - --strip-components=1
ENV	PATH=/opt/code-server:$PATH

##
## gtest
##
RUN	cd /usr/src/gtest && \
	cmake CMakeLists.txt && \
	make && \
	cp *.a /usr/lib

RUN	$CONDA_DIR/bin/pip  install --index-url https://test.pypi.org/simple/ \
	       --extra-index-url https://pypi.org/simple jupyter-codeserver-proxy==1.0b3

##	$CONDA_DIR/bin/pip  install --index-url https://test.pypi.org/simple/ \
##	       --extra-index-url https://pypi.org/simple jupyter-gdbgui-proxy==1.0b3 && \
##	$CONDA_DIR/bin/pip  install gdbgui

RUN	$CONDA_DIR/bin/pip install --pre jupyter-lsp && \
	jupyter labextension install @krassowski/jupyterlab-lsp && \
	conda install -c conda-forge python-language-server r-languageserver && \
	jupyter labextension install @jupyterlab/google-drive

##
## Build jupyter lab extensions
##
RUN	jupyter lab build

COPY	start-notebook.d /usr/local/bin/start-notebook.d

#
# Prevent core dumps, get rid of jovyan which will be over-mounted
#
RUN	rm -rf /home/jovyan  && \
	mkdir /home/jovyan && \
	chown $NB_UID:$NB_GID /home/jovyan && \
	rm -rf /usr/local/bin/fix-permissions

USER	$NB_UID
