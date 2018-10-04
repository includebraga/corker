defmodule Corker.ConfigTest do
  use ExUnit.Case, async: true
  doctest Corker.Config

  alias Corker.Config

  describe "os_env!/1" do
    test "loads the correct environment variable" do
      assert Config.os_env!("HOME")
    end

    test "raises an error if an env variable is not set" do
      assert_raise RuntimeError, "os env fake-env-var not set!", fn ->
        Config.os_env!("fake-env-var")
      end
    end
  end

  describe "config/3" do
    test "returns the default value if there is no application env variable" do
      Application.put_env(:corker, __MODULE__, test_value: 2)

      assert 1 == Config.config(:test, :other_value, 1)
      assert 1 == Config.config(__MODULE__, :other_value, 1)
    end

    test "returns the correct application env variable if set" do
      Application.put_env(:corker, __MODULE__, test_value: 1)

      assert 1 == Config.config(__MODULE__, :test_value)
    end

    test """
    uses the system env if the application env variable is in the {:system, var} format
    """ do
      Application.put_env(:corker, __MODULE__, test_value: {:system, "HOME"})

      assert System.get_env("HOME") == Config.config(__MODULE__, :test_value)
    end
  end

  describe "config!/2" do
    test "raises an error if there is no application env variable" do
      Application.put_env(:corker, __MODULE__,
        test_value: {:system, "fake-env-var"}
      )

      assert_raise RuntimeError, "os env fake-env-var not set!", fn ->
        Config.config!(__MODULE__, :test_value)
      end

      assert_raise RuntimeError, "other_value not set!", fn ->
        Config.config!(__MODULE__, :other_value)
      end
    end

    test "returns the correct application env variable if set" do
      Application.put_env(:corker, __MODULE__, test_value: 1)

      assert 1 == Config.config!(__MODULE__, :test_value)
    end

    test """
    uses the system env if the application env variable is in the
    {:system, var} format
    """ do
      Application.put_env(:corker, __MODULE__, test_value: {:system, "HOME"})

      assert System.get_env("HOME") == Config.config!(__MODULE__, :test_value)
    end
  end
end
