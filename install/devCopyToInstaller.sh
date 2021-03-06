#!/bin/bash
# Copyright 2017-present Open Networking Foundation
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# This script is for development use. It copies all of the
# required files and directories to the installer VM to
# allow changes to be made without having to rebuild the
# VM and it's registry which is time consuming.

# usage devCopyTiInstaller.sh <ip-address>


rm -f install.cfg
hosts=""
for i in `virsh list | awk '{print $2}' | grep ha-serv`
do
hosts="$hosts "`virsh domifaddr $i | tail -n +3 | head -n 1 | awk '{print $4}' | sed -e 's~/.*~~'`
done
echo "hosts=\"$hosts\"" >> install.cfg


ipAddr=`virsh domifaddr "Ubuntu1604LTS-1" | tail -n +3 | head -n 1 | awk '{print $4}' | sed -e 's~/.*~~'`

ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -i key.pem vinstall@$ipAddr rm -fr *
scp -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -i key.pem installer.sh vinstall@$ipAddr:installer.sh
scp -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -i key.pem install.cfg vinstall@$ipAddr:install.cfg
scp -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -i key.pem -r ansible vinstall@$ipAddr:ansible
scp -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -i key.pem -r ~/cord/incubator/voltha/compose vinstall@$ipAddr:compose
scp -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -i key.pem -r ~/cord/incubator/voltha/nginx_config vinstall@$ipAddr:nginx_config
