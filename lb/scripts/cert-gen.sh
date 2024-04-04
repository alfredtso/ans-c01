#!/bin/bash

openssl req \
  -verbose \
  -newkey ec:./ecp.pem \
  -x509 \
  -sha512 \
  -days 365 \
  -nodes \
  -out cert.pem \
  -keyout privatekey.pem




