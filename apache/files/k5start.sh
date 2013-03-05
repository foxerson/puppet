#! /bin/sh
### BEGIN INIT INFO
# Provides:             k5start
# Required-Start:       openafs-client
# Required-Stop:        openafs-client
# Should-Start:         $syslog $named openafs-fileserver
# Should-Stop:          openafs-fileserver
# X-Start-Before:		openafs-client
# X-Stop-After:         autofs
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
. /lib/lsb/init-functions

NAME=k5start

DAEMON=/usr/bin/k5start
PIDFILE=/var/run/k5start.pid
K5START_OPTS="-t -U -K 24h -b -p $PIDFILE"

test -x $DAEMON || exit 1

# this file must exist.
if [ -f /etc/default/k5start ]; then
	. /etc/default/k5start
else
	log_daemon_msg "$K5START cannot source /etc/default/k5start" 
	log_end_msg 0
fi

# service principal checked
if [ -z $KEYTAB ]; then 
  log_daemon_msg "Please set KEYTAB pointing to your service principal keytab" 
  log_eng_msg 1
  exit 1  
fi

KOPTS="$K5START_OPTS -f $KEYTAB"

k5start_running () {
        if [ -e $PIDFILE ]; then 
           if ! pidofproc -p $PIDFILE $DAEMON; then          
               return 1
           fi
        else
           if ! pidofproc $DAEMON; then     
             return 1
           fi
        fi

        return 0
}

case $1 in
   start)
		if [ `k5start_running` ]; then
		   log_daemon_msg "$NAME is already running"
		   log_end_msg 1
		else
		  	# start the daemon
		    log_daemon_msg "Obtaining service ticket" "$NAME"
		    start-stop-daemon --start --quiet --oknodo --pidfile $PIDFILE --exec $DAEMON -- $KOPTS
		    log_end_msg 0
		fi
	    ;;
   stop)
		if [ `k5start_running` ]; then
			log_daemon_msg "Killing $NAME"
			start-stop-daemon --stop --quiet --oknodo --exec $DAEMON 
			/bin/rm -rf $PIDFILE
			log_end_msg 0
		else
			log_daemon_msg "$NAME is not running"
			log_end_msg 1
		fi
		;;
	restart)
		$0 stop
		sleep 2
		$0 start
		;;
	status)
		status_of_proc $DAEMON "$NAME process"
		;;
	*)
		echo "Usage: $0 {start|stop|restart|status}"
		exit 2
		;;
esac
