# Configures session key logging and executes client test handshakes
$env:SSLKEYLOGFILE="$(Get-Location)\tls_keylog.log"

Write-Host "1. Testing Pure PQC (ML-KEM-768)..."
docker run --rm -v ${PWD}:/export -e SSLKEYLOGFILE=/export/tls_keylog.log openquantumsafe/curl curl -k --tlsv1.3 --curves mlkem768 https://host.docker.internal:4433/

Write-Host "2. Testing BSI Hybrid (X25519MLKEM768)..."
docker run --rm -v ${PWD}:/export -e SSLKEYLOGFILE=/export/tls_keylog.log openquantumsafe/curl curl -k --tlsv1.3 --curves X25519MLKEM768 https://host.docker.internal:4433/

Write-Host "3. Testing FrodoKEM (frodo640shake)..."
docker run --rm -v ${PWD}:/export -e SSLKEYLOGFILE=/export/tls_keylog.log openquantumsafe/curl curl -k --tlsv1.3 --curves frodo640shake https://host.docker.internal:4433/