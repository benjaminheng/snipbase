# Snipbase

## Setup

### Dependencies

1. [Ruby](http://rubyinstaller.org/downloads/) 2.1.x or above
2. [Ruby Development Kit](http://rubyinstaller.org/downloads/)
3. [PostgreSQL](http://www.postgresql.org/)

### Database Setup

Create the database user (default: snipbase).

```
$ psql postgres
postgres=> create role snipbase with createdb login password '<your_database_password>';
```

### App Setup

Set your database password as an environment variable.

- \*nix: `export PG_PASSWORD=<your_database_password>`
- Windows: `set PG_PASSWORD=<your_database_password>`

Install gem dependencies and initialize database.

```
$ bundle install
$ rake db:create
$ rake db:schema:load
```

Start the server.

```
$ rails server
```
