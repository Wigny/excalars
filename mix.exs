defmodule Excalars.MixProject do
  use Mix.Project

  def project do
    [
      app: :excalars,
      version: "0.4.0",
      elixir: "~> 1.18",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      aliases: aliases()
    ]
  end

  def application do
    [
      extra_applications: [:logger]
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  defp deps do
    [
      {:ecto, "~> 3.12", optional: true},
      {:postgrex, ">= 0.0.0", optional: true},
      {:phoenix_html, "~> 4.2", optional: true},
      {:ex_phone_number, "~> 0.4", optional: true},
      {:ex_email, "~> 1.0", optional: true},
      {:easyhtml, "~> 0.3", optional: true},
      {:doctest_formatter, "~> 0.4", env: :dev, runtime: false},
      {:mix_test_interactive, "~> 4.3", only: :dev, runtime: false}
    ]
  end

  defp aliases do
    [
      check: [
        "deps.get --check-locked",
        "format --check-formatted",
        "deps.unlock --check-unused",
        "compile --no-optional-deps --warnings-as-errors"
      ]
    ]
  end
end
