defmodule Corker.Slack.Messages do
  @messages YamlElixir.read_from_file!("config/messages.yml")

  def t(key) do
    keys = key |> String.split(".")

    case get_in(@messages, keys) do
      list when is_list(list) -> Enum.random(list)
      str when is_binary(str) -> str
      _ -> ""
    end
  end

  def t(key, opts) do
    key
    |> t()
    |> EEx.eval_string(opts)
  end
end
