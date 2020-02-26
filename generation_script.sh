#/bin/bash

# set -x

# The use of ./ is so we can test the script outside of the container
# Workdir is set to 
CERT_DIR=./certificates
CONF_DIR=./container

# Check if certificate exists
if [ -e $CERT_DIR/$DOMAIN.crt ]
then
    echo "The certificate already exists, nothing to do"
    exit 0
fi

#----------------------------------------------
# Generation of root CA certificate
#----------------------------------------------

if [ ! -e $CERT_DIR/$CA_NAME.pem ]
then
    echo "Creating the Certification Authority..."
    openssl genrsa -out $CERT_DIR/$CA_NAME.key 2048
    openssl req -x509 -new -nodes -key $CERT_DIR/$CA_NAME.key -sha256 -days 1048576 -out $CERT_DIR/$CA_NAME.pem -config <( cat $CONF_DIR/$CA_NAME.cnf )
    echo "Certification Authority created."
fi

if [ ! -e $CERT_DIR/$CA_NAME.key ]
then
    echo "Certification authority key not found. Aborting"
    exit 1
fi

#----------------------------------------------
# Generation of domain csr
#----------------------------------------------

# Create a configuration file if not proviede in /certificates directory
if [ ! -e $CERT_DIR/$DOMAIN.cnf ]
then
    echo "Generating a new configuration file"
    #cp /container/dummyDomain.cnf /tmp/$DOMAIN.cnf
    sed 's/${DOMAIN}/'$DOMAIN/ < $CONF_DIR/dummyDomain.cnf > /tmp/$DOMAIN.cnf
else
    echo "Copying provided configuration to /tmp"
    cp $CERT_DIR/$DOMAIN.cnf /tmp/$DOMAIN.cnf
fi

# CSR generation
openssl req -new -sha256 -nodes \
-out /tmp/$DOMAIN.csr \
-newkey rsa:2048 -keyout $CERT_DIR/$DOMAIN.private.key \
-config <( cat /tmp/$DOMAIN.cnf )

#----------------------------------------------
# Generation of domain crt
#----------------------------------------------

openssl x509 -req \
-in /tmp/$DOMAIN.csr \
-CA $CERT_DIR/$CA_NAME.pem -CAkey $CERT_DIR/$CA_NAME.key \
-CAcreateserial -CAserial /tmp/$DOMAIN.srl \
-out $CERT_DIR/$DOMAIN.crt



















