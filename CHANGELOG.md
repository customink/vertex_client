# VertexClient Changelog

This file tracks all the changes made to the client.
This allows parsers such as Dependabot to provide a clean overview in pull requests.

## v2.0.0
- Added more documentation
- Added actual tests against the Vertex staging system
- Cleaned out the `$LOAD_PATH` usage, following bundler standards
- Removed the usage of `autoload` as this is considered a bad-practise
- Cleaned out gem versions and usage
- Removed `circuitbox`, downstream users should implement their error handling
- Added `rubocop` for code quality and consistency
- Rewrote the entire test-suite to respect the Minitest conventions
- Fixed the Module names to respect autoload conventions
- Set default timeout for Savon operations to 5 seconds.

## v0.7.0

- Introduced CHANGELOG.md
- Migrated to CircleCI for testing
