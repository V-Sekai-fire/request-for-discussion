# Copyright (c) 2026 K. S. Ernest (iFire) Lee
# SPDX-License-Identifier: MIT

import Config

config :logger, level: :info

config :rfd, serve: false, port: 8080

if config_env() == :prod, do: config(:rfd, serve: true)
