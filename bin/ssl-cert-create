#!/bin/bash
#
source ~/local/lib/WIP_BLOCKER.sh
#
# A script to generate ssl key and certificate for *internal* use

# Default to generate everything in the current directory
OUT=$(pwd)

function createRootCA {
    openssl genrsa -des3 -out rootCA.key 2048

    # TODO Make the following call non-interactive
    openssl req -x509 -new -nodes \
            -key rootCA.key \
            -sha256 \
            -days 1024 \
            -out rootCA.pem
}

# NOTE by default, I use my previously created and imported rootCA
# Its key and pem is stored in my pass store
function getRootCA {
    pass rootCA/crystal.cw.pem > rootCA.pem
    pass rootCA/crystal.cw.key  > rootCA.key
}

# NOTE create csr.cnf and v3.ext
function init {
    cat - <<END > server.csr.cnf
[req]
default_bits = 2048
prompt = no
default_md = sha256
distinguished_name = dn

[dn]
C=CN
ST=Beijing
L=Beijgin
O=End Point
OU=One Crystal Site
emailAddress=xiongc05@gmail.com
CN = cvultr25.cw
END

    cat - << END > v3.ext
authorityKeyIdentifier=keyid,issuer
basicConstraints=CA:FALSE
keyUsage = digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment
subjectAltName = @alt_names

[alt_names]
DNS.1 = localhost
DNS.2 = cvultr25.cw
IP.1 = 104.238.134.120
END

    echo '* INFO: edit file server.csr.cnf and v3.ext to set CN and alt_names.'
    echo '* INFO: You need to repeat the CN in the alt_names (Do not know why ;P)'
}

function createSelfSignedServerCert {
    if [ ! -e server.csr.cnf -o ! -e  v3.ext ]; then
        echo '* Error: server.csr.cnf or v3.ext is not found in the current working directory, run init first.'
        exit 1
    fi
    # creating self-signed certificate
    openssl req -new -sha256 -nodes \
            -out server.csr \
            -newkey rsa:2048 \
            -keyout server.key \
            -config <( cat server.csr.cnf )

    # NOTE:
    # 1. -CAcreateserial, if not set, a serial file needs to be supplied
    # 2. v3.ext is needed for subjectAltName setting
    openssl x509 -req \
            -in server.csr \
            -CA rootCA.pem -CAkey rootCA.key \
            -CAcreateserial \
            -out server.crt \
            -days 500 -sha256 \
            -extfile v3.ext

    cat server.key server.crt > server.pem

    echo "* INFO: upon deployment, saved server.pem in your pass store."
}

cmd="$1"
case $cmd in
    rootCA)
        createRootCA
        ;;
    init)
        init
        ;;
    self-cert)
        createSelfSignedServerCert
        ;;
    *)
        echo "* Error: not recognizing $cmd."
        ;;
esac
