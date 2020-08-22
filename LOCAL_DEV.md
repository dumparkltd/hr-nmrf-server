# LOCAL DEVELOPMENT (WIP)

---

## Prerequisites (Ubuntu 20, no Docker)

This project requires:

* Ruby 2.3.3, preferably managed using [rbenv][]
  - You might need to install other linux packages so gems can build
  - If installing on Ubuntu 20, [follow these instructions](https://www.garron.me/en/linux/install-ruby-2-3-3-ubuntu.html).
* Install the bundler version found in *Gemfile.lock*: `gem install bundler -v 1.16.1`
* PhantomJS (in order to use the [poltergeist][] gem)
* PostgreSQL must be installed and accepting connections
  - Create a role with your logged username and make it a superuser with the below command
  -  `sudo -u postgres createuser --interactive`

## Set MinIO to replace AWS S3
* Install https://github.com/minio/minio#gnulinux
* Run with default values

## Set up secrets

```
cp config/secrets-sample.yml config/secrets.yml
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


Generate a secret:

```
rake secret
```

## Set env files
* create two copies of the `example.env` file, one named `.env` the other named `.envrc`
* Set the following values in both files
      export SADATA_SECRET_KEY_BASE=<the generated secret>
      export AWS_ACCESS_KEY_ID=minioadmin
      export AWS_SECRET_ACCESS_KEY=minioadmin

## Setup script

Run the `bin/setup` script. This script will:

* Check you have the required Ruby version
* Install gems using Bundler
* Create local copies of `.env` and `database.yml`
* Create, migrate, and seed the database

## Run it!

1. Run `rake spec` to make sure everything works.
2. Run `rails s` to start the Rails app.
