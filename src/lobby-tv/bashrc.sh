
# sudo raspi-config
# source /apps/alegria/src/lobby-tv/bashrc.sh
echo "========================================"
echo "=== DISPLAY: $DISPLAY"
echo "=== SHLVL:   $SHLVL"
echo "=== SSH_CLIENT: $SSH_CLIENT"
echo "=== SSH_TTY:    $SSH_TTY"
echo "========================================"
echo
if test -n "$SSH_CLIENT" || test -n "$SSH_TTY" ; then
  echo "=== Skipping slideshow. ==="
else
  echo
  echo
  if [ -z "$DISPLAY" ] && test -z "$SSH_CLIENT" && ! pgrep -x fbi && test "$SHLVL" -lt 2 ; then
    /apps/alegria/sh/run lobby-tv || echo "!!! Done with exit status: $?"
  fi
  echo "=== Slideshow has ended. ==="
fi

