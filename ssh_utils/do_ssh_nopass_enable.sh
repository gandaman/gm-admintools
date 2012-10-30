#!/bin/sh
# ============================================================================
# Project:	LUPIN
#
# Description:	Enable SSH authentication without password request
#
# Language:	Unix Shell Script
#
# Required packages:
#	openssh-client
#
# See also:
#	LupinWiki:[[Secure_authentication_with_SSH_without_password_request]]
#
# Usage examples:
#	do_ssh_nopass_enable.sh root@gianpinas.homelinux.net
# ============================================================================

# ---------------------------------------------------------------------------
# Configurable parameters
# ---------------------------------------------------------------------------

# NONE

# ---------------------------------------------------------------------------
# Main Program
# ---------------------------------------------------------------------------

#set -x
set -e

PROGNAME=`basename $0`
echo "INFO: ${PROGNAME} - v0.2"

usage() {
    echo "Usage: ${PROGNAME} remoteuser@remotehost"
    exit 1
}

if [ $# -lt 1 ]; then
    usage
fi

# Check that parameter has the right format
echo $1 | grep -q -P '^[0-9a-z_\-\.]+@[0-9a-z_\-\.]+$' 
if [ $? != 0 ] ; then
   usage
fi

REMOTEUSER=`echo $1 | sed -e 's/\@.*$//'`
REMOTEHOST=`echo $1 | sed -e 's/^.*@//'`

echo "INFO: Enabling automatic login to ${REMOTEUSER}@${REMOTEHOST}"
if [ ! -e ${HOME}/.ssh/id_rsa.pub ]; then
    echo "WARNING: Missing SSH public/private keypair"
    ssh-keygen
fi
cat ${HOME}/.ssh/id_rsa.pub | ssh ${REMOTEUSER}@${REMOTEHOST} \
"mkdir -p .ssh && cd .ssh && cat >>authorized_keys && chmod 640 authorized_keys"

# === EOF ===
