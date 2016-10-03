Supported tags and respective `Dockerfile` links
================================================

  * [`latest`](https://github.com/wernight/docker-spdyproxy/blob/master/Dockerfile) [![](https://images.microbadger.com/badges/image/wernight/spdyproxy.svg)](http://microbadger.com/images/wernight/spdyproxy "Get your own image badge on microbadger.com")


What is SPDY Proxy?
===================

**[SPDY Proxy](https://libraries.io/npm/spdyproxy)** is a fast, secure forward proxy. It acts as a secure proxy to access the internet via it: Secure connection to proxy and ability to tunnel HTTP, HTTPS, and SPDY.

Allows to encrypt via TSL to a proxy server your entire browsing network accesses which may **speed up** (if your server has better network than the machine running your browser), **bypass** network web filters/firwalls (for example if you server is in another country and you're in China).

### Features

Features of this Dockerized image:

  * **Simple**: Exposes default port, generate self-signed certificate unless provided.
  * **Secure**: Runs as non-root UID/GID `1593` (selected randomly to avoid mapping to an existing user), and supports basic auth.


### Usage

    $ docker run -d --net=host wernight/spdyproxy

Note: `--net=host` is required for SPDY pings to be handled, outside of it, only port TCP `44300` is used.

It's recommended that you provide a valid certificate, or at least self-sign one for your domain by mounting them as `/ssl/server.key` and `/ssl/server.crt` (you can mount as read-only, just check that user `1593` has read access to them). It'll **generate a self-signed certificate** if there isn't one already, however, it'll be signed for your **current public IP** address (you may also link it to a data-only container to preserve the generate certificate).

You can require **basic authentication** by specifying environment variables `SPDY_USERNAME` and `SPDY_PASSWORD`.

#### Client-side setup

Once running, you may setup your [compatible Browser](http://caniuse.com/#feat=spdy) to use your server.

 1. Check it works by connecting to `https://203.0.113.0` (replace `203.0.113.0` by your server hostname/IP) and it may show an infinite load but it should *not* show a untrustued certificate screen. If you're not using a trusted certificate (e.g. self-signed), you'll have to import the certificate PEM (`/ssl/server.crt` used by *spdyproxy*) as an **authority** for **websites**:
      * Chrome on Linux:
         1. Settings > Show advanced settings > HTTPS/SSL > Manage Certificates
         2. Authorities tab > Import the certificate file you just downloaded.
         3. ☑ Trust for Websites
      * Chrome on Mac: 
         1. Settings > Show advanced settings > HTTPS/SSL > Manage Certificates
         2. File > Import Items…
 2. Create a PAC script, simplest on Chrome is using [SwitchyOmega](https://chrome.google.com/webstore/detail/proxy-switchyomega/padekgcemlokbadohgkifijomclgjgif), like below (replace `203.0.113.0` by the hostname or IP of your server running *spdyproxy*):

        function FindProxyForURL(url, host) {
          // Tries to go through proxy and falls back to direct connection.
          return "HTTPS 203.0.113.0:44300; DIRECT";
        }

 3. If you've set up a user/password, click the lock icon next to the PAC Script on *SwitchyOmega* to input your username/password.
