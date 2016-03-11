defmodule Wanderer.Mixfile do
  use Mix.Project

  def project do
    [app: :wanderer,
     version: "0.0.1",
     elixir: "~> 1.2",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps]
  end

  def application do
    [applications: [:logger],
     mod: {Wanderer, []}]
  end

  defp deps do
    [
      {:roombex, "~> 0.0.4"}
    ]
  end
end
