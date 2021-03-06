#!/bin/bash
##############################################################################
# Copyright (c) 2015 Ericsson AB and others.
#
# All rights reserved. This program and the accompanying materials
# are made available under the terms of the Apache License, Version 2.0
# which accompanies this distribution, and is available at
# http://www.apache.org/licenses/LICENSE-2.0
##############################################################################

# Perepare the environment to run yardstick ci

: ${INSTALLER_TYPE:='fuel'}
: ${INSTALLER_IP:='10.20.0.2'}
: ${DEPLOY_TYPE:='bm'} # Can be any of 'bm' (Bare Metal) or 'virt' (Virtual)

: ${NODE_NAME:='unknown'}
: ${EXTERNAL_NETWORK:='admin_floating_net'}


# Extract network name from EXTERNAL_NETWORK
#  e.g. EXTERNAL_NETWORK='ext-net;flat;192.168.0.2;192.168.0.253;192.168.0.1;192.168.0.0/24'
export EXTERNAL_NETWORK=$(echo $EXTERNAL_NETWORK | cut -f1 -d \;)

echo
echo "INFO: Creating openstack credentials .."

# Create openstack credentials
OPENRC=/home/opnfv/openrc
if [ ! -f $OPENRC ]; then
    if [ "$DEPLOY_TYPE" == "virt" ]; then
        FETCH_CRED_ARG="-v -d $OPENRC -i ${INSTALLER_TYPE} -a ${INSTALLER_IP}"
    else
        FETCH_CRED_ARG="-d $OPENRC -i ${INSTALLER_TYPE} -a ${INSTALLER_IP}"
    fi

    $RELENG_REPO_DIR/utils/fetch_os_creds.sh $FETCH_CRED_ARG

fi

source $OPENRC

export EXTERNAL_NETWORK INSTALLER_TYPE DEPLOY_TYPE NODE_NAME
