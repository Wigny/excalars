defmodule Excalars.MixProject do
  use Mix.Project

  def project do
    [
      app: :excalars,
      version: "0.2.0",
      elixir: "~> 1.18",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      deps: deps()
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
      {:doctest_formatter, "~> 0.4", env: :dev, runtime: false},
      {:mix_test_watch, "~> 1.2", only: [:dev, :test], runtime: false}
    ]
  end
end
