# frozen_string_literal: true

# Configuration for DotEnv.
# This file will attempt to load any ENV test file if they are present
require 'dotenv'

files = []
files << File.expand_path('../../.env.test', __dir__) if File.exist?(File.expand_path('../../.env.test', __dir__))
files << File.expand_path('../../.env', __dir__)

Dotenv.load(*files)
