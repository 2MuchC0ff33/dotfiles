#!/bin/sh
# Start D-Bus session
if [ -z "$DBUS_SESSION_DBUS_ADDRESS" ]; then
	eval $(dbus-launch --sh-syntax --exit-with-sesion)
fi
exec dwm
