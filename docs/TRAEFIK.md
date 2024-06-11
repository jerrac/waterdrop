# Using Traefik
If you use Traefik to route traffic, in dev, or otherwise, here are some suggested labels for configuring your Drupal services:

Enable Traefik:
```yaml
        traefik.enable: "true"
        traefik.docker.network: "TRAEFIK_PUBLIC_NETWORK"
```

Non-https configuration:
```yaml
        traefik.http.routers.PROJECTNAME-http.entrypoints: "web"
        traefik.http.routers.PROJECTNAME-http.rule: "Host(`PROJECTNAME.MY.TLD`)"
        traefik.http.routers.PROJECTNAME-http.service: "PROJECTNAME-app"
        traefik.http.services.PROJECTNAME-app.loadbalancer.server.port: "80"
```

https configuration with redirect:
```yaml
        traefik.http.middlewares.PROJECTNAME-redirect.redirectscheme.scheme: "https"
        traefik.http.middlewares.PROJECTNAME-redirect.redirectscheme.permanent: "true"
        traefik.http.routers.PROJECTNAME-http.entrypoints: "web"
        traefik.http.routers.PROJECTNAME-http.rule: "Host(`PROJECTNAME.MY.TLD`)"
        traefik.http.routers.PROJECTNAME-http.service: "PROJECTNAME-app"
        traefik.http.routers.PROJECTNAME-http.middlewares: "PROJECTNAME-redirect"
        traefik.http.routers.PROJECTNAME-secure.entrypoints: "websecure"
        traefik.http.routers.PROJECTNAME-secure.tls: "true"
        traefik.http.routers.PROJECTNAME-secure.tls.certresolver: "REPLACE_WITH_CONFIGURED_ACME_SERVER"
        traefik.http.routers.PROJECTNAME-secure.rule: "Host(`PROJECTNAME.MY.TLD`)"
        traefik.http.routers.PROJECTNAME-secure.service: "PROJECTNAME-app"
        traefik.http.services.PROJECTNAME-app.loadbalancer.server.port: "80"
```
