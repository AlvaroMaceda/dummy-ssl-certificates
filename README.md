# dummy-ssl-certificates

Image to generate dummy ssl certificates for development

## Usage

```docker run --user $(id -u):$(id -g) -ti --rm --mount type=bind,source=$(pwd)/certificates,target=/certificates --env DOMAIN=development.host.com dummy-ssl-certificates```

This will generate the following files into ./certificates directory:
- A dummy Certification Authority certificate (dummyRootCA.pem) and key(dummyRootCA.key). You must import the certification authority in your browser.
- A dummy ssl certificate (development.host.com.crt) and key (development.host.private.key). You will use them in your web server.

If you need a new certificate for development for another host you can run the container again using the same certificates directory; it will detect the existing dummy certification authority and will use it, so you won't need to install it on the browser again.
