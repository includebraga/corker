defmodule Corker.Feedback do
  import Ecto.Query, warn: false

  alias Corker.Feedback.HighFive
  alias Corker.Repo

  def create_high_five(attrs \\ %{}) do
    %HighFive{}
    |> HighFive.changeset(attrs)
    |> Repo.insert()
  end

  def high_fives_since(receiver_id, time) do
    query =
      from h in HighFive,
        where: h.receiver_id == ^receiver_id and h.inserted_at > ^time

    Repo.all(query)
  end

  def high_fives_between(receiver_id, start_time, end_time) do
    query =
      from h in HighFive,
        where:
          h.receiver_id == ^receiver_id and h.inserted_at > ^start_time and
            h.inserted_at <= ^end_time

    Repo.all(query)
  end
end
