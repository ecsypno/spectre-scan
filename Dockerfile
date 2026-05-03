# syntax=docker/dockerfile:1
FROM ubuntu:22.04

RUN groupadd -g 1234 spectre-group
RUN useradd -m -u 1234 -g spectre-group spectre
RUN chmod 644 /etc/resolv.conf /etc/hosts || true

USER spectre
 
WORKDIR /home/spectre

RUN echo '#!/usr/bin/env bash' > ./setup.sh
RUN echo 'bash -c "$(curl -sSL https://spectre-scan.sh)"' >> ./setup.sh
RUN chmod +x ./setup.sh

# Auto-run setup on the first interactive shell. Touch a semaphore once
# attempted so we don't loop on partial installs / rerun on every exec.
# Override with `docker compose run -e SKIP_SETUP=1 app bash`.
RUN cat >> ~/.bashrc <<'EOF'

if [[ -z "$SKIP_SETUP" ]] && [[ $- == *i* ]] && [[ ! -e "$HOME/.setup-attempted" ]]; then
    touch "$HOME/.setup-attempted"
    echo "Spectre Scan not installed — running setup..."
    # Trap INT so a Ctrl+C during setup still removes the semaphore, otherwise
    # bash aborts the rest of this block before the failure branch runs.
    trap 'rm -f "$HOME/.setup-attempted"; trap - INT' INT
    if ! "$HOME/setup.sh"; then
        rm -f "$HOME/.setup-attempted"
        echo "Setup failed. Re-enter the shell to retry or re-run ./setup.sh." >&2
    fi
    trap - INT
fi
EOF

USER root

RUN apt-get update
RUN apt-get install -y nano tzdata less curl libgconf-2-4 libatk1.0-0 libatk-bridge2.0-0 libgdk-pixbuf2.0-0 libgtk-3-0 \
  libgbm-dev libnss3-dev libxss-dev libasound2

ENV TZ=Etc/UTC
RUN ln -fs /usr/share/zoneinfo/$TZ /etc/localtime && dpkg-reconfigure -f noninteractive tzdata

USER spectre
