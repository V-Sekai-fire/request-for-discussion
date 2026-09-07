# Copyright (c) 2026 K. S. Ernest (iFire) Lee
# SPDX-License-Identifier: MIT

import Config

if port = System.get_env("PORT"), do: config(:rfd, port: String.to_integer(port))
if System.get_env("RFD_SERVE") == "1", do: config(:rfd, serve: true)
