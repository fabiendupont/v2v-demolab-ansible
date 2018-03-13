#!/bin/bash

MANAGEIQ_DIR="/home/miq/manageiq"
MANAGEIQ_UI_DIR="/home/miq/manageiq-ui-classic"
RETVAL=0

# Load default environment and variables
source "/etc/profile.d/rh-ruby24.sh"

miq_start() {
  cd $MANAGEIQ_DIR
  bundle exec rake evm:start
  RETVAL=$?
  return $RETVAL
}

miq_stop() {
  cd $MANAGEIQ_DIR
  bundle exec rake evm:stop
  RETVAL=$?
  return $RETVAL
}

miq_kill() {
  cd $MANAGEIQ_DIR
  bundle exec rake evm:kill
  RETVAL=$?
  return $RETVAL
}

miq_restart() {
  cd $MANAGEIQ_DIR
  bundle exec rake evm:restart
  RETVAL=$?
  return $RETVAL
}

miq_status() {
  cd $MANAGEIQ_DIR
  bundle exec rake evm:status
  RETVAL=$?
  return $RETVAL
}

miq_update_start() {
  cd $MANAGEIQ_DIR
  bundle exec rake evm:update_start >> /var/www/miq/vmdb/log/evm.log 2>&1
  RETVAL=$?
  return $RETVAL
}

miq_update_stop() {
  cd $MANAGEIQ_DIR
  bundle exec rake evm:update_stop >> /var/www/miq/vmdb/log/evm.log 2>&1
  RETVAL=$?
  return $RETVAL
}

ui_start() {
  cd $MANAGEIQ_UI_DIR
  NODE_ENV=development ./node_modules/.bin/webpack-dev-server --config config/webpack/development.js
  RETVAL=$?
  return $RETVAL
}

ui_kill() {
  PID=`netstat -lntp | grep '0.0.0.0:8080' | awk '{ print $7; }' | awk -F '/' '{ print $1; }'`
  kill -9 $PID
  RETVAL=$?
  return $RETVAL
}

ui_restart() {
  ui_kill
  ui_start
}

# See how we were called.
case "$1" in
  start)
    miq_start
    ui_start
    ;;
  stop)
    ui_kill
    miq_stop
    ;;
  kill)
    ui_kill
    miq_kill
    ;;
  status)
    miq_status
    ;;
  restart)
    miq_restart
    ui_restart
    ;;
  update_start)
    miq_update_start
    ui_start
    ;;
  update_stop)
    ui_kill
    miq_update_stop
    ;;
  *)
    echo $"Usage: $prog {start|stop|restart|status}"
    exit 1
esac

exit $RETVAL
