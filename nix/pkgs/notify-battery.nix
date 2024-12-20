{ pkgs, ... }:

pkgs.writeShellApplication {
  name = "notify-battery";

  runtimeInputs = with pkgs; [
    acpi
    bash
    coreutils
    dbus
  ];

  text = ''
    set +o nounset
    set +o pipefail

    export DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/1000/bus"
    export DISPLAY=:0

    # Battery percentage at which to notify.
    BATTERY_DISCHARGING=$(acpi -b | grep "Battery 0" | grep -c "Discharging")
    BATTERY_LEVEL=$(acpi -b | grep "Battery 0" | grep -P -o '[0-9]+(?=%)')
    WARNING_LEVEL=20

    # Use two files to store whether we've shown a notification or not (to prevent multiple notifications).
    EMPTY_FILE=/tmp/battery-empty
    FULL_FILE=/tmp/battery-full

    # Reset notifications if the computer is charging/discharging.
    if [ "$BATTERY_DISCHARGING" -eq 1 ] && [ -f $FULL_FILE ]; then
      rm $FULL_FILE
    elif [ "$BATTERY_DISCHARGING" -eq 0 ] && [ -f $EMPTY_FILE ]; then
      rm $EMPTY_FILE
    fi

    # If the battery is charging and is full (and has not shown notification yet).
    if [ "$BATTERY_LEVEL" -gt 95 ] && [ "$BATTERY_DISCHARGING" -eq 0 ] && [ ! -f $FULL_FILE ]; then
      notify-send "Battery Charged" "Battery is fully charged." -r 9991
      touch $FULL_FILE
    # If the battery is low and is not charging (and has not shown notification yet).
    elif [ "$BATTERY_LEVEL" -le $WARNING_LEVEL ] && [ "$BATTERY_DISCHARGING" -eq 1 ] && [ ! -f $EMPTY_FILE ]; then
      notify-send "Low Battery" "''${BATTERY_LEVEL}% of battery remaining." -u critical -r 9991 -t 0
      touch $EMPTY_FILE
    fi
  '';
}
