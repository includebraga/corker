defmodule Corker.Slack.ActionsTest do
  use ExUnit.Case, async: true

  alias Corker.Slack.{
    Actions,
    Messages
  }

  describe "parse/2" do
    test "replies with error when receiving unknown DMs" do
      state = %{}

      response = Actions.parse(%{channel: "DIRECTMESSAGEID"}, state)

      assert {:reply, Messages.t("error.dm_received")} == response
    end

    test "doesn't reply to messages where not tagged" do
      state = %{id: "BOTID"}
      message = %{text: "I like my wheelchair"}

      response = Actions.parse(message, state)

      assert :noreply == response
    end

    test "replies with unknown command to bad tags" do
      state = %{id: "BOTID"}
      message = %{text: "<@BOTID> I like my wheelchair", user: "123"}

      response = Actions.parse(message, state)

      assert {:reply, Messages.t("error.unknown_command")} == response
    end
  end
end
