# Use local.devex.com to access your Vagrant Box

If you want to access your vagrant box via local.devex.com, you have to do the steps described below.

## 1. Define local.devex.com

Add the following line to `/etc/hosts`:
```
127.0.0.1  local.devex.com
```

## 2. Make https://local.devex.com work without a port

### Linux

Run the following commands as root to forward port 433 (https default) to 8443 (vagrant port for https):

```
sysctl net.ipv4.ip_forward=1
iptables -t nat -I PREROUTING -p tcp --dport 443 -j REDIRECT --to-ports 8443
iptables -t nat -I OUTPUT -p tcp -o lo --dport 443 -j REDIRECT --to-ports 8443
iptables -t nat -A POSTROUTING -j MASQUERADE
```

### Mac OS X

This explanation is based on the [guide posted on "Brian's Blog"](http://blog.brianjohn.com/forwarding-ports-in-os-x-el-capitan.html).

#### 1. Make sure the OS X firewall is enabled

Go to `System Preferences > Security & Privacy > Firewall` and make sure the firewall is turned on. This is needed to have `pfctl` available.

#### 2. Create an anchor file

The first file we need to add is an anchor file. This defines the ports we want to forward. Create a file `/etc/pf.anchors/com.devex` with the following content:

```
rdr pass on lo0 inet proto tcp from any to any port 443 -> 127.0.0.1 port 8443
```

After this, you can test your configuration via:

```
sudo pfctl -vnf /etc/pf.anchors
```

This won't enabled the forwarding yet, but if you don't see any errors than the file is properly created.

#### 3. Creating a `pfctl` config file

Once your anchor file checks out, you need to add a pfctl config file. Create this file under `/etc/pf-devex.conf` and add the following contents.

```
rdr-anchor "forwarding"
load anchor "forwarding" from "/etc/pf.anchors/com.devex"
```

#### 4. Starting the forwarding manually

You can start pfctl using the below command. This will forward the ports according to your rules.

```
sudo pfctl -ef /etc/pf-devex.conf
```

To stop forwarding ports run the same command, replacing the `e` option with `d`.

```
sudo pfctl -df /etc/pf-devex.conf
```

#### 5. Forwarding ports at startup

You can use the commands above to start port forwarding on demand if you wish, otherwise if (like me) you want to forward ports automatically at startup you can create a [launchctl plist file](https://developer.apple.com/library/content/documentation/MacOSX/Conceptual/BPSystemStartup/Chapters/CreatingLaunchdJobs.html). 

Create a file under `/Library/LaunchDaemons/com.apple.pfctl-devex.plist` with the following contents:

```
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
     <key>Label</key>
     <string>com.apple.pfctl-devex</string>
     <key>Program</key>
     <string>/sbin/pfctl</string>
     <key>ProgramArguments</key>
     <array>
          <string>pfctl</string>
          <string>-e</string>
          <string>-f</string>
          <string>/etc/pf-devex.conf</string>
     </array>
     <key>RunAtLoad</key>
     <true/>
     <key>KeepAlive</key>
     <false/>
</dict>
</plist>
```

Add the file to startup using the following command:

```
sudo launchctl load -w /Library/LaunchDaemons/com.apple.pfctl-devex.plist
```
