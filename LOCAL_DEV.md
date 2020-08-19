# LOCAL DEVELOPMENT (WIP)

---

## Prerequisites (Ubuntu 18, no Docker)

This project requires:

* Ruby 2.3.3, preferably managed using [rbenv][]
* PhantomJS (in order to use the [poltergeist][] gem)
* PostgreSQL must be installed and accepting connections

## Set MinIO to replace AWS S3
* Install https://github.com/minio/minio#gnulinux
* Run with default values

## Set up secrets

```
cp config/secrets-sample.yml config/secrets.yml
```

and edit. You can generate a new secret to use, like this:

```
rake secret
```

## Set up Devise

```
cp config/initializers/devise-sample.rb config/initializers/devise.rb
```

Then edit to include a secret_key, example:

```
# rubocop:disable Metrics/LineLength
config.secret_key = 'your-secret-goes-here'
# rubocop:enable Metrics/LineLength
```

## Set env files
* create two copies of the `example.env` file, one names `.env` the other named `.envrc`
* Set the following values in both files
      SADATA_SECRET_KEY_BASE=<get a new value from 'rake secret'>
      AWS_ACCESS_KEY_ID=minioadmin
      AWS_SECRET_ACCESS_KEY=minioadmin

## Setup script

Run the `bin/setup` script. This script will:

* Check you have the required Ruby version
* Install gems using Bundler
* Create local copies of `.env` and `database.yml`
* Create, migrate, and seed the database

## Run it!

1. Run `rake spec` to make sure everything works.
2. Run `rails s` to start the Rails app.
