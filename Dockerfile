#
# You need to change the BASE_CONTAINER in the Makefile, not here
#
ARG BASE_CONTAINER=this/is-a-place-holder
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
				   emacs-nox \
				   libgtest-dev cmake-curses-gui \
				   net-tools \
				   openssh-client gdb \
				   build-essential libc6-dev-i386 man \
				   valgrind gcc-multilib g++-multilib libgmp-dev\
				   software-properties-common python3-software-properties curl gnupg \
		mysql-client apt-transport-https psmisc graphviz graphviz-dev vim nano ffmpeg \
		 fonts-dejavu \
		 gfortran \
		 googletest libopencv-dev \
		 clang lldb \
		 rustc rust-gdb lldb python3-lldb && \
	rm -rf /var/lib/apt/lists/*


RUN    $CONDA_DIR/bin/pip install -U nbgitpuller jupyterlab-git jupyterlab_latex jupyterlab-drawio jupyterlab-link-share

RUN	curl https://cli-assets.heroku.com/install.sh | sh

RUN     conda install -c conda-forge --freeze-installed \
              libiconv python-language-server flake8 autopep8 \
	      altair vega_datasets \
	      bokeh datashader holoviews \
              jupyter-server-proxy cppcheck && \
	jupyter labextension install --no-build @jupyterlab/server-proxy && \
        conda clean -afy

#
# openpyxl is for pandas.read_excel
#
RUN	pip install networkx pygraphviz pydot pyyaml openpyxl

#RUN     (cd /tmp && \
#        git clone https://github.com/jupyterhub/jupyter-server-proxy && \
#        cd /tmp/jupyter-server-proxy/jupyterlab-server-proxy && \
#        npm install && npm run build && jupyter labextension link . && \
#	rm -rf /tmp/jupyter-server-proxy )
#
# jupyter-LSP appears to cause hangs -- see https://github.com/krassowski/jupyterlab-lsp/issues/200
#
#	$CONDA_DIR/bin/pip install --pre jupyter-lsp && \
#	jupyter labextension install @krassowski/jupyterlab-lsp && \
#
# Not ready for prime time
#
#	jupyter labextension install @jupyterlab/google-drive && \


RUN	cd /opt && \
	wget https://github.com/cdr/code-server/releases/download/v3.11.1/code-server_3.11.1_amd64.deb && \
	dpkg -i ./code-server*.deb && \
	rm -f ./code-server*.deb

##
## gtest
##
RUN	cd /usr/src/gtest && \
	cmake CMakeLists.txt && \
	make && \
	cp lib/*.a /usr/lib

RUN	$CONDA_DIR/bin/pip  install --index-url https://test.pypi.org/simple/ \
	       --extra-index-url https://pypi.org/simple jupyter-codeserver-proxy==1.0b4

##	$CONDA_DIR/bin/pip  install --index-url https://test.pypi.org/simple/ \
##	       --extra-index-url https://pypi.org/simple jupyter-gdbgui-proxy==1.0b3 && \
##	$CONDA_DIR/bin/pip  install gdbgui

##
## Real time collaboration -- works in the container but not with jupyterhub/z2jh yet
##
## RUN	pip install jupyterlab-link-share

##
## jupyter-archive
##
RUN conda install -c conda-forge nodejs jupyter-archive

##
## Build jupyter lab extensions
##
RUN	jupyter lab build --dev-build=False && jupyter lab clean

COPY	start-notebook.d /usr/local/bin/start-notebook.d
#COPY	start-notebook.d /usr/local/bin/before-notebook.d

#
# Prevent core dumps, get rid of jovyan which will be over-mounted
#
RUN	rm -rf /home/jovyan  && \
	mkdir /home/jovyan && \
	chown $NB_UID:$NB_GID /home/jovyan

USER	$NB_UID
