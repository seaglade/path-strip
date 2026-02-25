# `path-strip`

This is a simple docker container built on `nginx:alpine` that generates an `nginx.conf` given two environment variables. I made this because Cloudflare Tunnels cannot handle path stripping, and I wanted to put a FastAPI server behind a Cloudflare Tunnel route on a subpath.

As an example, let's say you want `https://somewhere.example/a/*` to be proxied to `http://service:80/*`:

| Environment Variable |    Correct Value    | Purpose                                                             |
| :------------------: | :-----------------: | ------------------------------------------------------------------- |
| `STRIP_PATH_PREFIX`  |         `a`         | Sets the subpath of the proxied endpoint. MUST NOT have a leading / |
| `STRIP_PATH_TARGET`  | `http://service:80` | Sets the target for the proxy. MUST NOT have a trailing /           |

Now, if you set your reverse proxy to hit `path-strip` on port 80, `https://somewhere.example/a/b` will be proxied to `http://service:80/b`.

`path-strip` can handle more complex use cases as well. Let's say you want `https://somewhere.example/a/*` to be proxied to `http://service:80/b/*`. Use the above config, except add `/b` to `STRIP_PATH_TARGET`. Now, `https://somewhere.example/a/c` is proxied to `http://service:80/b/c`.

## Example Docker Compose

```yaml
services:
  echo:
    image: mendhak/http-https-echo
  path-strip:
    image: gghcr.io/seaglade/path-strip:latest
    environment:
      STRIP_PATH_PREFIX: a
      STRIP_PATH_TARGET: http://echo:8080
```
