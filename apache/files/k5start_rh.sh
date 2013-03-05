#! /bin/sh
### BEGIN INIT INFO
# Provides:             k5start
# Required-Start:       openafs-client
# Required-Stop:        openafs-client
# Default-Start:        2 3 4 5
# Default-Stop:         0 1 6
# Short-Description:    k5start
# Description:          Starts or stops k5start for service keytab, 
#						getting the service tokens as necessary. 
#						Outside PAG only
### END INIT INFO
#
# Modified by Frederiko Costa<fcosta@stanford.edu> for Debian
# Copyright 2000, International Business Machines Corporation and others.
# All Rights Reserved.
# 
# Runs k5start in background mode with the keytab provided 
# at KEYTAB variable. User must update correspondend KEYTAB
# file at /etc/default/k5start

# loading lsb functions to perform the operations
. /etc/init.d/functions

NAME=k5start

DAEMON=/usr/bin/k5start
PIDFILE=/var/run/k5start.pid
K5START_OPTS="-t -U -K 500 -b -p $PIDFILE"

test -x $DAEMON || exit 1

# this file must exist.
if [ -f /etc/sysconfig/k5start ]; then
	. /etc/sysconfig/k5start
else
	echo "$NAME cannot source /etc/sysconfig/k5start" 
	exit 1
fi

# service principal checked
if [ -z $KEYTAB ]; then 
  echo "Please set KEYTAB pointing to your service principal keytab"
  exit 1
fi

KOPTS="$K5START_OPTS -f $KEYTAB"

k5start_running () {
        if [ -e $PIDFILE ]; then 
           if pidofproc -p $PIDFILE $DAEMON -eq 3; then          
               return 1
           fi
        else
           if pidofproc $DAEMON -eq 3; then     
             return 1
           fi
        fi

        return 0
}

case $1 in
   start)
		if [ `k5start_running` ]; then
		   status $NAME
		else
		  	# start the daemon
		    echo -n $"Obtaining service ticket: " 
			daemon $DAEMON $KOPTS
			echo
		fi
	    ;;
   stop)
		echo -n $"Killing $NAME: " 
		if [ `k5start_running` ]; then
			killproc $DAEMON 
		else
			failure $"Killing $NAME"
		fi
		echo
		;;
	restart)
		$0 stop
		sleep 1
		$0 start

		;;
	status)
		status $NAME
		;;
	*)
		echo "Usage: $0 {start|stop|restart|status}"
		exit 2
		;;
esac
