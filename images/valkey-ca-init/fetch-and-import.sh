#!/bin/sh
set -eu

# This script fetches the Valkey CA certificate from the Google Cloud Memorystore API and
# imports it into the system CA bundle and Java cacerts keystore.

echo "Get the access token using Workload Identity Federation (WIF) to authenticate to the Google Cloud Memorystore API"
TOKEN="$(curl -sSf \
  -H 'Metadata-Flavor: Google' \
  'http://metadata.google.internal/computeMetadata/v1/instance/service-accounts/default/token' \
  | grep -o '"access_token":"[^"]*"' | cut -d'"' -f4)"

echo "Fetching the Valkey CA certificate from the Memorystore API"
curl -sSf -H "Authorization: Bearer ${TOKEN}" \
  "https://memorystore.googleapis.com/v1/projects/${VALKEY_PROJECT}/locations/${VALKEY_LOCATION}/instances/${VALKEY_INSTANCE_NAME}/certificateAuthority" \
  -o /truststore/ca-response.json

echo "Extracting the Valkey CA certificate from the API response and saving it to /truststore/valkey-ca.pem"
grep -o '"-----BEGIN CERTIFICATE-----[^"]*-----END CERTIFICATE-----[^"]*"' /truststore/ca-response.json \
  | sed 's/^"//; s/"$//; s/\\n/\n/g' > /truststore/valkey-ca.pem

echo "Appending the Valkey CA certificate to the system CA bundle and Java cacerts keystore"
cp /etc/ssl/certs/ca-certificates.crt /truststore/ca-bundle.pem
cat /truststore/valkey-ca.pem >> /truststore/ca-bundle.pem

echo "Importing the Valkey CA certificate into the Java cacerts keystore"
cp "${JAVA_HOME}/lib/security/cacerts" /truststore/cacerts
keytool -importcert -noprompt \
  -alias valkey-ca \
  -file /truststore/valkey-ca.pem \
  -keystore /truststore/cacerts \
  -storepass changeit

echo "Valkey CA certificate has been successfully imported into the Java cacerts keystore"
