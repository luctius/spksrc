#! /bin/sh
#
### BEGIN INIT INFO
# Provides:          tinc
# Required-Start:    $remote_fs $network
# Required-Stop:     $remote_fs $network
# Should-Start:      $syslog $named
# Should-Stop:       $syslog
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: Start tinc daemons
# Description:       Create a file $NETSFILE (/etc/tinc/nets.boot),
#                    and put all the names of the networks in there.
#                    These names must be valid directory names under
#                    $TCONF (/etc/tinc). Lines starting with a # will be
#                    ignored in this file.
### END INIT INFO
#
# Based on Lubomir Bulej's Redhat init script.


# Package
PACKAGE="tinc"

# Others
INSTALL_DIR="/usr/local/${PACKAGE}"
ETC_DIR="${INSTALL_DIR}/etc/${PACKAGE}"
PATH="${INSTALL_DIR}/bin:/usr/local/bin:/bin:/usr/bin:/usr/syno/bin"
RUNAS="tinc"
TINC="${INSTALL_DIR}/bin/tinc-daemon"
PID_FILE="${INSTALL_DIR}/var/run/tinc"

DAEMON="${INSTALL_DIR}/sbin/tincd"
NAME="tinc"
DESC="tinc daemons"
NETSFILE="${ETC_DIR}/nets.boot"
NETS=""

test -f $DAEMON || exit 0

# foreach_net "what-to-say" action [arguments...]
foreach_net() {
  if [ ! -f $NETSFILE ] ; then
    echo "Please create $NETSFILE."
    exit 0
  fi
  echo -n "$1"
  shift
  egrep '^[ ]*[a-zA-Z0-9_-]+' $NETSFILE | while read net args; do
    echo -n " $net"
    "$@" $net $args
  done
  echo "."
}

signal_running() {
  for i in ${PID_FILE}.*pid; do
    if [ -f "$i" ]; then
      head -1 $i | while read pid; do
        kill -$1 $pid
      done
    fi
  done
}

start() {
  $DAEMON $EXTRA -n "$@"
}
stop() {
  $DAEMON -n $1 -k
}
reload() {
  $DAEMON -n $1 -kHUP
}
alarm() {
  $DAEMON -n $1 -kALRM
}
restart() {
  stop "$@"
  sleep 0.5
  i=0;
  while [ -f $PID_FILE.$1.pid ] ; do
	if [ $i = '10' ] ; then
		break
	else
		echo -n "."
		sleep 0.5
		i=$(($i+1))
	fi		
  done
  start "$@"
}

case "$1" in
  start)
    foreach_net "Starting $DESC:" start
  ;;
  stop)
    foreach_net "Stopping $DESC:" stop
  ;;
  reload|force-reload)
    foreach_net "Reloading $DESC configuration:" reload
  ;;
  restart)
    foreach_net "Restarting $DESC:" restart
  ;;
  alarm)
    signal_running ALRM
  ;;
  *)
    echo "Usage: /etc/init.d/$NAME {start|stop|reload|restart|force-reload|alarm|status}"
    exit 1
  ;;
esac

exit 0
