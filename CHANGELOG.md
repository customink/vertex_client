# VertexClient Changelog

This file tracks all the changes (https://keepachangelog.com/en/1.0.0/) made to the client. This allows parsers such as Dependabot to provide a clean overview in pull requests.

## [v0.9.2] - 2020-07-06

#### Added

- Quotation, Invoice and DistributeTax payloads now accept a `:tax_only_adjustment` param to make tax adjustments that need not be correlated with a total cost adjustment

## [v0.9.1] - 2020-03-24

#### Added

- Set quotation fallback rates for EU
- Allow optional `country` attribute of `customer` (allows VAT calculation for EU if Vertex client is set up properly)

#### Changed

- Update quotation validation rules to require either `state` (case of US address) or `country` (other countries)


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
