#
# Jupyterhub setup for Biocoding 2018
#
##########   IMPORTANT   #############
# To work properly, git clone https://github.com/JasonJWilliamsNY/docker_jupyterhub_config
# use the following command to start the container
# docker run -p 8000:8000 --name jupyterhub -d -v SOMEPATH/jupyter-persistant:/jupyter-persistant jasonjwilliamsny/ubuntu-jhub-dev2.3:latest
#
# Based on Ubuntu
FROM ubuntu:bionic-20180710
#
#
# Maintained by
MAINTAINER Jason Williams "williams@cshl.edu"
#
#
# Install some required tools
RUN apt-get update
RUN apt-get install -y\
 apt-utils\
 dialog\
 software-properties-common\
 build-essential gcc\
 libssl-dev\
 openssl\
 npm nodejs\
 wget\
 git\
 bzip2\
 tmux
#
#
# Install python related tools and packages
RUN apt-get install -y\
 python3.6-dev\
 python3-pip\
 python3.6-venv
#
#
# Install and configure required npm stuff
RUN npm config set registry="http://registry.npmjs.org/"
RUN npm install -g configurable-http-proxy
#
#
# Use python to install hub and related hub items and nice packages
RUN python3 -m pip install\
 notebook\
 jupyterhub\
 sudospawner\
 numpy\
 scipy\
 matplotlib\
 pandas\
 'plotnine[all]'\
 jupyter_contrib_nbextensions\
 jupyter_nbextensions_configurator\
 ipywidgets\
 bash_kernel
#
#
# Activate and configure python/hub addins
RUN jupyter contrib nbextension install --system
RUN jupyter nbextensions_configurator enable --system
RUN jupyter nbextension enable --py --sys-prefix widgetsnbextension
RUN python3 -m bash_kernel.install
#
#
# Expose port 8000
EXPOSE 8000
#
# Start the container - will create users in username.txt if they do
# not already exist and start the hub.
CMD ["jupyter-persistant/createusers.sh"]
