defmodule ExZendesk.Mixfile do
  use Mix.Project

  def project do
    [app: :ex_zendesk,
     version: "0.1.0",
     elixir: "~> 1.3",
     description: description(),
     package: package(),
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps()]
  end

  def application do
    [applications: [:logger, :httpoison, :poison]]
  end

  defp deps do
    [{:httpoison, "~> 0.9.0"}, {:poison, "~> 2.0"}]
  end

  defp description do
    """
    A simple HTTPoison wrapper for interacting with the Zendesk API
    """
  end

  defp package do
    [name: :ex_zendesk,
     maintainers: ["Andrew Schmid"],
     licenses: ["MIT"],
     links: %{"GitHub" => "https://github.com/storestartup/ex_zendesk"}]
  end
end
