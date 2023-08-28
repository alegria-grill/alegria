
# sudo raspi-config
# source /apps/alegria/src/lobby-tv/bashrc.sh
if [ -z "${DISPLAY}" ] && ! pgrep -x fbi && test "$SHLVL" -lt 1 ; then
  exec /apps/alegria/sh/run lobby-tv
fi
