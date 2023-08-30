
# sudo raspi-config
# source /apps/alegria/src/lobby-tv/bashrc.sh
set -x
if [ -z "$DISPLAY" ] && ! pgrep -x fbi && test "$SHLVL" -lt 2 ; then
  { /apps/alegria/sh/run lobby-tv && echo "=== Slideshow has ended. ==="  || echo "!!! Done with exit status: $?"
fi
set +x

