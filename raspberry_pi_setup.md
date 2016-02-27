__Initial Operating System Setup__

I'm using the [2015-11-21 Jessie Lite](https://downloads.raspberrypi.org/raspbian_lite/images/raspbian_lite-2015-11-24/2015-11-21-raspbian-jessie-lite.zip) image.
After you have burned it to an SD card and booted it up you can login (username `pi`, password `raspberry`).
Now run `sudo raspi-config` and make the following changes.

* Expand the file system to use the whole MicroSD Card
* Change the default user password (optional)
* Change the default locale to en-US UTF-8 UTF-8
* Change the timezone to America/Denver
* Change the keyboard layout to a US layout
* Change the hostname to piN (I name my name `pi1`, `pi2`, etc)

__Setup Wifi Credentials__

Your Wifi credentials will depend on the network that you connect to.
We like to bring our own WiFi router to events and always try to configure out robots to connect to that router.
First you'll want to make sure that your `/etc/network/inerfaces` file looks like:

```
source-directory /etc/network/interfaces.d

auto lo
iface lo inet loopback

iface eth0 inet manual

allow-hotplug wlan0
iface wlan0 inet dhcp
    wpa-conf /etc/wpa_supplicant/wpa_supplicant.conf
```

This tells the pi to allow a USB Wifi module to be plugged/unplugged while it is running.
Next edit the `/etc/wpa_supplicant/wpa_supplicant.conf` file to look like:

```
ctrl_interface=DIR=/var/run/wpa_supplicant GROUP=netdev
update_config=1

network={
    ssid="pifi"
    psk="pifipifi"
    priority=5
}

network={
    ssid="development_wifi"
    psk="some-other-password"
    priority=2
}
```

Here we have setup two different WiFi credentials.
The `development_wifi` will be preferred (higher priority) and the `pifi` network will be used when that is unavailable.
Now on your raspberry-pi terminal you can run `sudo ifup wlan0` and it should load the configuration and try to connect to the wifi.

__Install Erlang, Elixir, OpenCV, and Ruby__

Run all of these commands as `root`:

```
echo "deb http://packages.erlang-solutions.com/debian wheezy contrib" >> /etc/apt/sources.list
wget http://packages.erlang-solutions.com/debian/erlang_solutions.asc
sudo apt-key add erlang_solutions.asc && rm erlang_solutions.asc
sudo apt-get update
apt-get install -y --force-yes erlang-mini upstart htop git ruby2.1 libopencv-dev ruby2.1-dev vim
mkdir /opt/elixir-1.2.3
curl  -L https://github.com/elixir-lang/elixir/releases/download/v1.2.3/Precompiled.zip -o /opt/elixir-1.2.3/precompiled.zip
cd /opt/elixir-1.2.3
unzip precompiled.zip
echo 'export PATH=/opt/elixir-1.2.3/bin:$PATH' >> /etc/bash.bashrc
export PATH=/opt/elixir-1.2.3/bin:$PATH
/opt/elixir-1.2.3/bin/mix local.hex --force
/opt/elixir-1.2.3/bin/mix local.rebar --force
```

Now reboot your pi so that upstart is running.
