FROM alpine
LABEL maintainer="Alvaro Maceda (http://alvaromaceda.es)"

WORKDIR /

# Name of certification authority file
ENV CA_NAME=dummyRootCA

# This is the domain we generate the certificate for
ENV DOMAIN=dummy.domain

# Install openssl
RUN apk update && \
  apk add --no-cache openssl bash && \
  rm -rf /var/cache/apk/*

COPY dummyRootCA.cnf dummyDomain.cnf generation_script.sh /container/

ENTRYPOINT ["/bin/bash", "/container/generation_script.sh"]

