# Handy

Collection of handy tools collected over a period of time.

## Installation

    gem 'handy'

And then execute:

    $ rake -T handy

## Settings

Besides having some useful rake tasks it also sets up a constant called
`Settings` if a file named `config/settings.yml` is present.

In Rails 4.1+ apps, this functionality is not needed because
of presence of `config/secrets.yml`.
