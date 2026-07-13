FROM eclipse-temurin:21-jre-jammy
RUN apt-get update && apt-get install -y --no-install-recommends curl \
    && apt-get clean && rm -rf /var/lib/apt/lists/*
COPY fetch-valkey-ca.sh /usr/local/bin/fetch-valkey-ca
RUN chmod +x /usr/local/bin/fetch-valkey-ca
ENTRYPOINT ["fetch-valkey-ca"]
