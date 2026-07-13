FROM eclipse-temurin:21-jre-jammy
RUN apt-get update && apt-get install -y --no-install-recommends curl \
    && apt-get clean && rm -rf /var/lib/apt/lists/*
COPY fetch-and-import.sh /usr/local/bin/fetch-and-import.sh
RUN chmod +x /usr/local/bin/fetch-and-import.sh
ENTRYPOINT ["/usr/local/bin/fetch-and-import.sh"]
