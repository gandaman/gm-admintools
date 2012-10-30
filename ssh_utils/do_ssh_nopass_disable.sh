#!/bin/sh
# ============================================================================
# Project:	LUPIN
#
# Description:	Disable SSH authentication without password request
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
#	do_ssh_nopass_disable.sh root@gianpinas.homelinux.net
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
echo "INFO: ${PROGNAME} - v0.1"

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

echo "INFO: Disabling automatic login to ${REMOTEUSER}@${REMOTEHOST}"

# This function makes no sense if keys are not available
if [ ! -e ${HOME}/.ssh/id_rsa.pub ]; then
    echo "Missing SSH public/private keypair. Nothing to do."
    exit
fi

cat ${HOME}/.ssh/id_rsa.pub | ssh ${REMOTEUSER}@${REMOTEHOST} \
"cd .ssh && \
cp authorized_keys authorized_keys.OLD && \
cat >disablekey.tmp && \
grep -v -f disablekey.tmp authorized_keys.OLD >authorized_keys && \
chmod 640 authorized_keys"

# === EOF ===
