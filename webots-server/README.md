# Webots Desktop Server

Run Webots on a JupyterHub - based on https://github.com/yuvipanda/jupyter-desktop-server

This is based on https://github.com/ryanlovett/nbnovnc and a fork of https://github.com/manics/jupyter-omeroanalysis-desktop

If a `vncserver` executable is found in `PATH` it will be used, otherwise a bundled TightVNC server is run.
You can use this to install vncserver with support for other features, for example the [`Dockerfile`](./Dockerfile) in this repository installs TurboVNC for improved OpenGL support.

