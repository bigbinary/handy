# Handy

Collection of handy tools collected over a period of time.

## Installation

    gem 'handy'

And then execute:

    $ rake -T handy

## Settings

Besides having some useful rake tasks it also sets up a constant called
`Settings`. It reads the `application.yml` file and populates
`Settings`.

You can use a separate file for each environment. Example `config/settings/development.yml` contains development settings.
