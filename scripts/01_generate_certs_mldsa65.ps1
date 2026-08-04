# Generates Root CA, Server CSR, and Signed Server Certificate using ML-DSA-65
docker run --rm -v ${PWD}:/export openquantumsafe/curl openssl req -x509 -new -newkey mldsa65 -keyout /export/mldsa_ca.key -out /export/mldsa_ca.crt -nodes -days 365 -subj '/CN=OQS Root'
docker run --rm -v ${PWD}:/export openquantumsafe/curl openssl req -new -newkey mldsa65 -keyout /export/server.key -out /export/server.csr -nodes -subj '/CN=localhost'
docker run --rm -v ${PWD}:/export openquantumsafe/curl openssl x509 -req -in /export/server.csr -CA /export/mldsa_ca.crt -CAkey /export/mldsa_ca.key -CAcreateserial -out /export/server.crt -days 365
