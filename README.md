![alt text](gfx/spectre-scan-banner.png)

Installation instructions for [Spectre Scan](https://ecsypno.com/pages/codename-scnr):

* [Docker installation](#docker-installation) -- All platforms.
   * [Updating](#updating)
   * [Caution!](#caution)
* [Automated installation](#automated-installation) -- for Linux x84 64bit.
* [Manual installation](#manual-installation) -- for Linux x84 64bit.
* [Dependencies for headless environments or WSL](#dependencies-for-headless-environments-or-wsl)
* [Environment variables](#environment-variables) -- for ops, air-gapped, multi-volume layouts.

**Enterprise customers requiring the client utilities to manage the [Scheduler](https://documentation.ecsypno.com/scnr/deployment/distributed/scheduler.html)
or [Agent](https://documentation.ecsypno.com/scnr/deployment/distributed/agent.html) can simply download the
[matching release](https://github.com/ecsypno/spectre-scan/releases) and use those executables.
There is no need for special installation instructions nor a license key.**

## Docker installation

```bash
mkdir spectre-scan && cd spectre-scan
curl -sSL https://compose.spectre-scan.sh > docker-compose.yml

docker compose pull
docker compose up -d # Start the services.

docker exec -it spectre-scan-app-1 bash # Connect to the container.
```

You can now run Spectre Scan by using the executables under the `spectre-scan-v*/bin` directory.

1. For a CLI scan you can run `bin/spectre URL`.
2. You can use Spectre Scan Pro by running `bin/spectre_pro`.

For more information please consult the [documentation](https://documentation.ecsypno.com/scnr/).

### Updating

You can run `./setup.sh` when a new version is released to install it automatically.

### Caution!

Use `docker compose stop` to stop the container, and `docker compose start` to start it again.

**DO NOT** use `docker compose up` nor `docker compose down`, as they will delete all filesystem
data.

## Automated installation

To install run the following command in a terminal of your choice:

```bash
bash -c "$(curl -sSL https://spectre-scan.sh)"
```

You can now run Spectre Scan by using the executables under the `spectre-scan-v*/bin` directory.

1. For a CLI scan you can run `bin/spectre URL`.
2. You can use Spectre Scan Pro by running `bin/spectre_pro`

For more information please consult the [documentation](https://documentation.ecsypno.com/scnr/).

## Manual installation

1. Download the [latest package](https://github.com/ecsypno/spectre-scan/releases).
2. Extract.
3. Activate: `bin/spectre_activate [LICENSE_KEY]`

You can now run Spectre Scan by using the executables under the `bin/` directory.

1. For a CLI scan you can run `bin/spectre URL`.
2. You can use Spectre Scan Pro by running `bin/spectre_pro`

For more information please consult the [documentation](https://documentation.ecsypno.com/scnr/).

## Dependencies for headless environments or WSL

For minimal environments such as headless servers or the Windows Subsystem for Linux, please first run:

```
sudo apt-get update
sudo apt-get install -y libgconf-2-4 libatk1.0-0 libatk-bridge2.0-0 \
  libgdk-pixbuf2.0-0 libgtk-3-0 libgbm-dev libnss3-dev libxss-dev libasound2

```

## Environment variables

These can be exported **before** running the installer (or before the first
invocation of any `bin/spectre*` executable) to override defaults. Most users
won't need any of them — they exist for ops folks running on shared boxes,
behind proxies, with separate disks, or in air-gapped environments.

### Home directory

| Variable | Default | What it does |
|---|---|---|
| `SPECTRE_HOME` | `~/.spectre` | Single root for **all** Spectre Scan user-scoped state — the encrypted `license` blob and plaintext `license.key`, scan reports, snapshots, engine logs, the embedded PostgreSQL data directory, and the `latest_version` stamp written by the auto-update check. Override this to put everything on a different volume (e.g. `SPECTRE_HOME=/mnt/scratch/spectre`). |

### Logs

| Variable | Default | What it does |
|---|---|---|
| `SPECTRE_ENGINE_LOG_DIR` | `$SPECTRE_HOME/logs/engine` | Engine-side run logs. |
| `SPECTRE_PRO_LOG_DIR` | `$SPECTRE_HOME/logs/pro` | Spectre Scan Pro (Rails) + bundled PostgreSQL logs. |

### Engine output

| Variable | Default | What it does |
|---|---|---|
| `SPECTRE_ENGINE_REPORTS_DIR` | `$SPECTRE_HOME/reports` | Where the engine writes scan reports (`.afr` archives, generated HTML/JSON/XML/text exports). Move to a larger volume if you keep a long history. |
| `SPECTRE_ENGINE_SNAPSHOTS_DIR` | `$SPECTRE_HOME/snapshots` | Suspended-scan session snapshots used by `resume`. Can grow large for long-running scans — point at a faster / bigger disk if needed. |

### Spectre Scan Pro database (embedded PostgreSQL)

| Variable | Default | What it does |
|---|---|---|
| `SPECTRE_PRO_DB_DIR` | `$SPECTRE_HOME/pro/db` | PostgreSQL cluster data dir (`initdb -D`). Move this to a faster / larger volume for big scans. |
| `SPECTRE_PRO_DB_SOCKET_DIR` | `$SPECTRE_HOME/pro/run` | Unix socket dir Pro connects on. |
| `SPECTRE_PRO_DB_NAME` | `spectre_pro` | Database name created on first start. |

### Engine

| Variable | Default | What it does |
|---|---|---|
| `SPECTRE_CHECK_SERVER` | `http://checks.ecsypno.com` | URL of the SSRF check server. Override it for air-gapped installs running their own `bin/spectre_check_server` — see the [air-gapped guide](https://documentation.ecsypno.com/scnr/how-to/run-air-gapped.html). |

### Networking

| Variable | Default | What it does |
|---|---|---|
| `SPECTRE_PROXY` | *(unset)* | Forwarded as `HTTP_PROXY` / `http_proxy` for the build's outbound calls (release feed lookup, dependency fetches, license server pings). |
| `CURL_CA_BUNDLE` / `SSL_CERT_FILE` | bundled `etc/ssl/ca/cacert.pem` | Override if you need to trust an enterprise / corporate CA bundle. |

### Standard

| Variable | What it does |
|---|---|
| `TMPDIR` | Where engine snapshot/work dirs are created (`Dir.mktmpdir`). Set to a large volume if your runs hit "no space left on device". |
| `TZ` | Falls into `Setting.detect_system_timezone` chain (after `Rails.application.config.time_zone` / `/etc/timezone` / `/etc/localtime`) when nothing else resolves. |

## License

Copyright 2026 [Ecsypno](https://ecsypno.com/).

All rights reserved.
