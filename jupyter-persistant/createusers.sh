#!/bin/bash

for user in $(cat /jupyter-persistant/usernames.txt)
  do
  if [ ! -L "/home/$user" ]
  then
      if [ ! -d "/jupyter-persistant/$user" ]
      then
          cp -r /jupyter-persistant/skel /jupyter-persistant/$user
          echo "Creating persistant folder for $user"
          base=$user
          password=$(openssl passwd -1 -salt xyz $base'.123')
          useradd -p $password $user
          ln -s /jupyter-persistant/$user /home/$user
          chown -R $user /jupyter-persistant/$user
          chown -R $user /home/$user
          echo "user $user added successfully!"
      else
          echo "Using existing persistant folder for $user"
          base=$user
          password=$(openssl passwd -1 -salt xyz $base'.123')
          useradd -p $password $user
          ln -s /jupyter-persistant/$user /home/$user
          chown -R $user /jupyter-persistant/$user
          chown -R $user /home/$user
          echo "user $user added successfully!"
      fi
  fi
  done
jupyterhub --ip 0.0.0.0 --port 8000 -f /jupyter-persistant/jupyterhub_config.py
