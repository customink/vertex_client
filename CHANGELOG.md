# VertexClient Changelog

This file tracks all the changes (https://keepachangelog.com/en/1.0.0/) made to the client. This allows parsers such as Dependabot to provide a clean overview in pull requests.

## [v0.9.0] - 2020-03-23

#### Added

- New `global` to yield full control of Savon/HTTPI configs.

#### Changed

- Make Net::HTTP the default HTTPI adapter.
- Set default global timeouts at 5 seconds.

#### Removed

- Adapter config in favor of Savon/HTTPI globals.


## [v0.8.0] - 2020-03-20

#### Added

- New HTTP adapter config.


## [v0.7.0]

#### Changed

- Introduced CHANGELOG.md
- Migrated to CircleCI for testing
