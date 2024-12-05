# VertexClient Changelog

This file tracks all the changes (https://keepachangelog.com/en/1.0.0/) made to the client. This allows parsers such as Dependabot to provide a clean overview in pull requests.

## [v0.11.1] - 2024-12-05

#### Changed

- Remove international quotation fallback rates to match Vertex level discontinuation of international sales tax collection
- Adjust domestic quotation fallback rates to better match current Vertex rates

## [v0.11.0] - 2024-04-03

#### Changed

- BREAKING: There are breaking changes when updating to `circuitbox` v2.0.0, which may require changes to this gem's `circuit_config`.
  - `logger` is deprecated. If needed, use `notifier` instead.
  - `cache` has been renamed to `circuit_store`.
  - Review the full list of changes in the [Circuitbox 2.0 Upgrade Guide](https://github.com/yammer/circuitbox/blob/main/docs/2.0-upgrade.md)

#### Added

- Adds compatibility with `circuitbox` v2.0.0 and retains compatibility with v1.1.1.

## [v0.10.1] - 2021-04-29

#### Changed

- Loosen quotation validation rules to only require `postal_code` for `US` based locations.

## [v0.10.0] - 2020-09-29

#### Added

- Quotation payload now accepts a `:delivery_term` param to specify delivery terms for quotation request
- Allow optional `physical_origin` attribute of `seller` in line item to help with specific VAT calculation use cases

#### Changed

- Update quotation validation rules to require either `state` (case of US address) or `country` (other countries) for line items with `seller` overrides that also specify `physical_origin`

## [v0.9.2] - 2020-07-07

#### Added

- Quotation, Invoice and DistributeTax payloads now accept a `:tax_only_adjustment` param to make tax adjustments that need not be correlated with a total cost adjustment

#### Changed

- Fix a bug with fallback quotation responses where an empty set of line items would raise `ArgumentError`

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
