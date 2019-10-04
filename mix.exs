defmodule ControlPlus.Mixfile do
  use Mix.Project

  def project do
    [
      app: :control_plus,
      version: "0.1.2",
      elixir: "~> 1.5",
      start_permanent: Mix.env == :prod,
      deps: deps(),
      test_coverage: [
        tool: ExCoveralls
      ],
      preferred_cli_env: [
        coveralls: :test,
        "coveralls.detail": :test,
        "coveralls.post": :test,
        "coveralls.html": :test,
        vcr: :test,
        "vcr.delete": :test,
        "vcr.check": :test,
        "vcr.show": :test
      ],
      dialyzer: [
        plt_add_deps: :transitive,
        check_plt: false,
        ignore_warnings: "./.dialyzer_ignore",
        flags: [
          :unknown,
          :unmatched_returns,
          :error_handling,
          :race_conditions,
        ],
      ],
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:cortex, ">= 0.0.0", [only: [:dev, :test]]},
      {:credo, ">= 0.0.0", [only: :dev, runtime: false]},
      {:ex_doc, ">= 0.0.0", [only: :dev, runtime: false]},
      {:dialyxir, ">= 0.0.0", [only: :dev, runtime: false]},
      {:excoveralls, ">= 0.0.0", [only: :test, runtime: false]},
      {:calendar, ">= 0.0.0"},
      {:exvcr, ">= 0.0.0", [only: :test]},
      {:hackney, ">= 0.0.0"},
      {:poison, ">= 0.0.0"},
      {:tesla, ">= 0.0.0"},
      {:timex, ">= 0.0.0"},
    ]
  end
end
