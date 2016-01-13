+++
date = "2015-03-18T14:19:00+07:00"
draft = false
title = "Some linux shortcuts"

+++

**iptables**

Accepting a port:

```
[sudo] iptables -A INPUT -i eth0 -p tcp --sport 3000 -j ACCEPT
```

Setting up port routing using (from port 80 to 8000):

```
[sudo] iptables -t nat -A PREROUTING -p tcp --dport 80 -j REDIRECT --to-ports 8000
```

Deleting existing rules:

```
[sudo] iptables -F
```

**get ip**

```
dig +short myip.opendns.com @resolver1.opendns.com
```

or if you don't have dig

```
curl eth0.me
```

**speed test**

Run this command and test the KB/s:

```
wget --output-document=/dev/null http://speedtest.wdc01.softlayer.com/downloads/test500.zip
```
