# Snipbase

A social and collaborative code snippet manager with GitHub Gists integration.

## Setup

### Dependencies

1. [Ruby](http://rubyinstaller.org/downloads/) 2.1.x or above
2. [Ruby Development Kit](http://rubyinstaller.org/downloads/) ([Install instructions](https://github.com/oneclick/rubyinstaller/wiki/Development-Kit))
3. [PostgreSQL](http://www.postgresql.org/)

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
