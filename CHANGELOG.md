## v0.7.0

- Introduced CHANGELOG.md
- added quotation fallback rates for EU
- add support for optional `country` attribute of `customer` (allows VAT calculation for EU if Vertex client is set up properly)
- update quotation validation rules to require either `state` (US) or `country` (other countries)
