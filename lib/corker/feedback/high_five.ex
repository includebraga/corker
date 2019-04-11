defmodule Corker.Feedback.HighFive do
  use Ecto.Schema
  import Ecto.Changeset

  @fields [:sender_id, :receiver_id, :reason]

  schema "high_fives" do
    field :reason, :string, null: false
    field :receiver_id, :integer, null: false
    field :sender_id, :integer, null: false

    timestamps()
  end

  def changeset(high_five, params \\ %{}) do
    high_five
    |> cast(params, @fields)
    |> validate_required(@fields)
  end
end
