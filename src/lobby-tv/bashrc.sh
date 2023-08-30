
# sudo raspi-config
# source /apps/alegria/src/lobby-tv/bashrc.sh
echo "========================================"
echo "=== DISPLAY: $DISPLAY"
echo "=== SHLVL:   $SHLVL"
echo "=== SSH_CLIENT: $SSH_CLIENT"
echo "=== SSH_TTY:    $SSH_TTY"
echo "========================================"
echo
if [ -z "$DISPLAY" ] && test -z "$SSH_CLIENT" && ! pgrep -x fbi && test "$SHLVL" -lt 2 ; then
  /apps/alegria/sh/run lobby-tv || echo "!!! Done with exit status: $?"
fi
echo
echo
echo "=== Slideshow has ended. ==="

