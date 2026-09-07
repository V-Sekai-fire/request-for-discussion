# Copyright (c) 2026 K. S. Ernest (iFire) Lee
# SPDX-License-Identifier: MIT

defmodule RFD.MixProject do
  use Mix.Project

  def project do
    [
      app: :rfd_dsl,
      version: "0.1.0",
      elixir: "~> 1.18",
      start_permanent: false,
      deps: []
    ]
  end

  def application do
    [extra_applications: [:logger]]
  end
end
