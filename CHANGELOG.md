# VertexClient Changelog

This file tracks all the changes made to the client.
This allows parsers such as Dependabot to provide a clean overview in pull requests.

## v0.7.1

- added quotation fallback rates for EU
- add support for optional `country` attribute of `customer` (allows VAT calculation for EU if Vertex client is set up properly)
- update quotation validation rules to require either `state` (US) or `country` (other countries)
- update README.md

## v0.7.0

- Introduced CHANGELOG.md
- Migrated to CircleCI for testing
