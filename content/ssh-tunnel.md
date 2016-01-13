+++
date = "2015-03-19T14:19:00+07:00"
draft = false
title = "SSH tunnel"

+++

SSH tunneling allows an individual to use their server as a proxy for their internet connection. This means that the bytes that you send and recieve from websites/servers will go through the server you're using.

The benefit of this is that it reduces the risk of your main computer being exposed as your IP becomes the servers IP, and all the requests to external websites/servers are made by the server rather than your computer. In addition, if you're in an external country you're able to use those servers to pretend like you're in another country. For example, if I want to watch netflix and I'm currently in China then I'm able to setup a SSH tunnel through a server in the US to watch netflix.

Basically the command is:

```
ssh -D 8080 -C -N username@servername
```

If you have your SSH keys in the authorized_keys of your server then you're set, but if you don't then enter the password for the user. Keep this connection open - you should not expect any output right away.

This will setup a proxy at port 8080 on your computer. The username is usually root for your server, but can be replaced if you created a new user. The servername is usually the IP of your server or the domain name. For example, my username@servername could be abhi@abhi.co where abhi is the username and abhi.co is the servername. Your hostname could be 28.254.39.67.

A sample command would be:

```
ssh -D 8080 -C -N abhi@abhi.co
```

The next step is limited to Mac OSX. Go to System Preferences, Network, Wifi/Ethernet (depending on what you're using to connect), Advanced, Proxy. Then turn on SOCKS Proxy with the details being 127.0.0.1:8080. This means that the input before the colon is 127.0.0.1, and the input after the colon is 8080.

Some people have [Hola](https://chrome.google.com/webstore/detail/hola-better-internet/gkojfkhlekighikafcpjkiklfbnlmeio?hl=en) installed on Chrome. Disable this if you're going to use the proxy with Chrome. Hola takes control of the proxy in Chrome when it's enabled (it's how it manages to connect you through different countries).

This step is for Linux. You have to export your http_proxy variable in order for this to work.

```
export http_proxy="http://127.0.0.1:8080"
```

Run this in the command line.

Now try and visit [whatismyip.com](http://whatismyip.com/), and see if the IP reflects the IP of your server. Congrats! You've just setup a SSH tunnel :) Or run this command in the command line!

```
dig +short myip.opendns.com @resolver1.opendns.com
```
