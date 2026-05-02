![alt text](gfx/spectre-scan-banner.png)

Installation instructions for [Spectre Scan](https://ecsypno.com/pages/codename-scnr):

* [Docker installation](#docker-installation) -- for Mac OSX, Linux and MS Windows. _(recommended)_
   * [Updating](#updating)
   * [Caution!](#caution)
* [Automated installation](#automated-installation) -- for Linux.
  * [PostgreSQL](#postgresql)
* [Manual installation](#manual-installation) -- for Linux.
* [Dependencies for headless environments or WSL](#dependencies-for-headless-environments-or-wsl)

**Enterprise customers requiring the client utilities to manage the [Scheduler](https://documentation.ecsypno.com/scnr/deployment/distributed/scheduler.html)
or [Agent](https://documentation.ecsypno.com/scnr/deployment/distributed/agent.html) can simply download the
[matching release](https://github.com/ecsypno/spectre-scan/releases) and use those executables.
There is no need for special installation instructions nor a license key.**

## Docker installation

Prerequisites:
* [Docker Compose](https://docs.docker.com/compose/)

```bash
mkdir spectre-scan && cd spectre-scan
curl -sSL https://compose.spectre-scan.sh > docker-compose.yml

docker compose pull
docker compose up -d # Start the services.
# "docker-compose" with the dash may be required on some systems.

docker exec -it spectre-scan-app-1 bash # Connect to the container.

# From within the container:
./setup.sh # Install Spectre Scan over the network.
```
_In some Linux distributions, you may need to preface the `docker` commands with `sudo`._

You can now run Spectre Scan by using the executables under the `spectre-scan-v*/bin` directory.

1. For a CLI scan you can run `bin/scnr URL`.
2. You can use Spectre Scan Pro by running `bin/scnr_pro`.

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

1. For a CLI scan you can run `bin/scnr URL`.
2. You can use Spectre Scan Pro by running `bin/scnr_pro`
   1. Setting up PostgreSQL is recommended for production workloads.

For more information please consult the [documentation](https://documentation.ecsypno.com/scnr/).

### PostgreSQL

For a more reliable Spectre Scan Pro experience, it's best to configure it to use PostgreSQL.

Please exchange `secret` with a secure password in the role creation commands.

#### Role creation

```
$ sudo -u postgres psql
postgres=# CREATE USER "scnr-pro" WITH PASSWORD 'secret';
postgres=# ALTER USER "scnr-pro" superuser;
```

#### Connection

```
# Backup SQLite config.
mv ~/.scnr/pro/config/database.yml ~/.scnr/pro/config/database.yml.bak

# Set to use PostgreSQL config.
cp ~/.scnr/pro/config/database.postgres.yml ~/.scnr/pro/config/database.yml
```

Now edit `~/.scnr/pro/config/database.yml` to change the password from `secret`.

#### Setup

From the Spectre Scan package directory:

    bin/scnr_pro_task db:setup

## Manual installation

1. Download the [latest package](https://github.com/ecsypno/spectre-scan/releases).
2. Extract.
3. Activate: `bin/scnr_activate [LICENSE_KEY]`

You can now run Spectre Scan by using the executables under the `bin/` directory.

For a CLI scan you can run `bin/scnr URL`.

For more information please consult the [documentation](https://documentation.ecsypno.com/scnr/).

### Spectre Scan Pro (WebUI)

You can run Spectre Scan Pro by running `bin/scnr_pro`.

If you'd like to use the Spectre Scan WebUI, its database will need to be prepared.

Out of the box, the WebUI comes configured with [SQLite](https://sqlite.org/index.html), however,
for better results and performance please switch to [PostgreSQL](https://www.postgresql.org/).

#### Setup

If this is a fresh installation, you can setup a DB with:

    ./bin/scnr_pro_task db:setup

#### Update

If you'd like to update an existing installation you can do it with:

    ./bin/scnr_pro_task db:migrate

#### PostgreSQL

##### Configuration

Please exchange `secret` with a secure password in the role creation commands.

###### Role creation

```
$ sudo -u postgres psql
postgres=# CREATE USER "scnr-pro" WITH PASSWORD 'secret';
postgres=# ALTER USER "scnr-pro" superuser;
```

###### Connection

From the package root directory:

```
# Backup SQLite config.
mv .system/scnr-ui-pro/config/database.yml .system/scnr-ui-pro/config/database.yml.bak

# Set to use PostgreSQL config.
cp .system/scnr-ui-pro/config/database.postgres.yml .system/scnr-ui-pro/config/database.yml
```

Now edit `.system/scnr-ui-pro/config/database.yml` to change the password from `secret`.

## Dependencies for headless environments or WSL

For minimal environments such as headless servers or the Windows Subsystem for Linux, please first run:

```
sudo apt-get update
sudo apt-get install libgconf-2-4 libatk1.0-0 libatk-bridge2.0-0 libgdk-pixbuf2.0-0 libgtk-3-0 libgbm-dev libnss3-dev libxss-dev libasound2 libicu-dev
```

## License

Copyright 2026 [Ecsypno](https://ecsypno.com/).

All rights reserved.
