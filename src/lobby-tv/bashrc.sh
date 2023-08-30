
# sudo raspi-config
# source /apps/alegria/src/lobby-tv/bashrc.sh
echo "========================================"
echo "=== DISPLAY: $DISPLAY"
echo "=== SHLVL:   $SHLVL"
echo "========================================"
echo
if [ -z "$DISPLAY" ] && ! pgrep -x fbi && test "$SHLVL" -lt 2 ; then
  /apps/alegria/sh/run lobby-tv || echo "!!! Done with exit status: $?"
fi
echo
echo
echo "=== Slideshow has ended. ==="

