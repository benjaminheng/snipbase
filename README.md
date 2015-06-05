# Snipbase [![Circle CI](https://img.shields.io/circleci/project/wryyl/snipbase.svg)](https://circleci.com/gh/wryyl/snipbase)

A social and collaborative code snippet manager with GitHub Gists integration.

## Setup

### Dependencies

**Core**

1. [Ruby](http://rubyinstaller.org/downloads/) (Tested with 2.1.x and above)
2. [Ruby Development Kit](http://rubyinstaller.org/downloads/) ([Install instructions](https://github.com/oneclick/rubyinstaller/wiki/Development-Kit))
3. [PostgreSQL](http://www.postgresql.org/)

**Development**

1. [Poltergeist](https://github.com/teampoltergeist/poltergeist) for Javascript-enabled acceptance tests

### Database Setup

Create the database user (default: snipbase).

```
$ psql -U postgres
postgres=# create role snipbase with createdb login password '<your_database_password>';
```

### App Setup

Set your database password as an environment variable.

- \*nix: `export PG_PASSWORD=<your_database_password>`
- Windows: `set PG_PASSWORD=<your_database_password>`

Install gem dependencies and initialize database.

```
$ gem install rails
$ bundle install
$ rake db:create
$ rake db:schema:load
```

Start the server.

```
$ rails server
```

## FAQ

**Why do I get `ExecJS::ProgramError` while trying to load the webpage on Windows?**

This is a known issue with ExecJS not working as expected on Windows machines using the default Javascript runtime. The easy fix is to install [Node.js](https://nodejs.org/).
