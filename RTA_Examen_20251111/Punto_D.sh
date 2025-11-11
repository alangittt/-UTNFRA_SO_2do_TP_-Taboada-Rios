#!/bin/bash

sudo groupadd 2PSupervisores
sudo usermod -aG 2PSupervisores alan
cd ~/UTN-FRA_SO_2do_TP_Taboada/202406/ansible
ansible-playbook playbook.yml
