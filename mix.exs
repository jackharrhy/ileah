defmodule ILeah.MixProject do
  use Mix.Project

  def project do
    [
      app: :ileah,
      version: "0.1.0",
      elixir: "~> 1.17",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      mod: {ILeah.Application, []},
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:nostrum, "~> 0.10"},
      {:dotenvy, "~> 0.8.0"},
    ]
  end
end
