# Copyright (c) 2026 K. S. Ernest (iFire) Lee
# SPDX-License-Identifier: MIT

defmodule RFD.MixProject do
  use Mix.Project

  def project do
    [
      app: :rfd,
      version: "0.2.0",
      elixir: "~> 1.20",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      releases: [rfd_site: [include_executables_for: [:unix]]]
    ]
  end

  def application do
    [extra_applications: [:logger], mod: {RFD.Application, []}]
  end

  defp deps do
    [
      {:ex_mcp, "1.0.0-rc.4"},
      {:plug_cowboy, "~> 2.7"},
      {:jason, "~> 1.4"},
      {:earmark, "~> 1.4"}
    ]
  end
end
