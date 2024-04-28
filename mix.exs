defmodule Excalars.MixProject do
  use Mix.Project

  def project do
    [
      app: :excalars,
      version: "0.1.0",
      elixir: "~> 1.15",
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
      {:ecto, "~> 3.10", optional: true},
      {:postgrex, ">= 0.0.0", optional: true},
      {:phoenix_html, "~> 3.3", optional: true},
      {:gettext, "~> 0.23", optional: true},
      {:timex, "~> 3.7", optional: true},
      {:ex_phone_number, "~> 0.4", optional: true}
    ]
  end
end
