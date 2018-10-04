defmodule Corker.Config do
  @spec os_env(String.t()) :: String.t() | nil
  def os_env(name) do
    System.get_env(name)
  end

  @spec os_env!(String.t()) :: String.t() | no_return
  def os_env!(name) do
    case os_env(name) do
      nil -> raise "os env #{name} not set!"
      value -> value
    end
  end

  @spec config(:atom, String.t(), term()) :: term()
  def config(mod, key, default \\ nil) do
    Application.get_env(:corker, mod, [])
    |> Keyword.get(key, default)
    |> parse_config_value()
  end

  @spec config(:atom, String.t()) :: term() | no_return
  def config!(mod, key) do
    Application.get_env(:corker, mod)
    |> parse_app_env!(key)
  end

  defp parse_config_value({:system, var}), do: os_env(var)
  defp parse_config_value(value), do: value

  defp parse_app_env!(nil, key), do: raise("#{key} not set!")

  defp parse_app_env!(args, key) do
    case Keyword.get(args, key) do
      nil -> raise "#{key} not set!"
      {:system, var} -> os_env!(var)
      value -> value
    end
  end
end
