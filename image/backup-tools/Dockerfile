FROM postgres:16

RUN apt-get update && \
    apt-get install -y --no-install-recommends curl bzip2 openssh-client ca-certificates && \
    curl -fsSL https://github.com/restic/restic/releases/download/v0.16.4/restic_0.16.4_linux_amd64.bz2 -o /tmp/restic.bz2 && \
    bzip2 -d /tmp/restic.bz2 && \
    mv /tmp/restic /usr/local/bin/restic && \
    chmod +x /usr/local/bin/restic && \
    apt-get purge -y curl bzip2 && apt-get autoremove -y && rm -rf /var/lib/apt/lists/*

ENTRYPOINT ["/bin/bash"]
