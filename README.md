# Syncthing Discovery Server

Dockerfile for [Syncthing Discovery Server](https://docs.syncthing.net/users/stdiscosrv.html), the discovery server for [Syncthing](https://syncthing.net/).

## Usage

Run:

```sh
docker run \
--rm \
-p 8443:8443 \
-p 19200:19200 \
-v $(pwd)/stdiscosrv:/stdiscosrv \
t13a/stdiscosrv \
```
