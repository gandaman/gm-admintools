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

if [ $# -lt 1 ]; then
    echo "Usage: ${PROGNAME} remoteuser@remotehost"
    exit 1
fi

REMOTEUSER=`echo $1 | sed -e 's/\@.*$//'`
REMOTEHOST=`echo $1 | sed -e 's/^.*@//'`

#echo "DEBUG: REMOTEUSER=$REMOTEUSER"
#echo "DEBUG: REMOTEHOST=$REMOTEHOST"

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
