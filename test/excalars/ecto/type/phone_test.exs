defmodule Excalars.Ecto.Type.PhoneTest do
  use ExUnit.Case

  alias Excalars.Ecto.Type.Phone, as: Type

  @phone %Excalars.Phone{number: 99_998_765_432, country: "BR"}

  describe "phone" do
    test "cast" do
      assert Ecto.Type.cast(
               {:parameterized, Type, %{country: nil}},
               "+55 (99) 99876-5432"
             ) == {:ok, @phone}

      assert Ecto.Type.cast(
               {:parameterized, Type, %{country: "BR"}},
               "(99) 99876-5432"
             ) == {:ok, @phone}

      assert Ecto.Type.cast(
               {:parameterized, Type, %{country: nil}},
               "(99) 99876-5432"
             ) == {:error, [message: "invalid country code"]}

      assert Ecto.Type.cast(
               {:parameterized, Type, %{country: nil}},
               @phone
             ) == {:ok, @phone}

      assert Ecto.Type.cast(
               {:parameterized, Type, %{country: "US"}},
               @phone
             ) == :error

      assert Ecto.Type.cast(
               {:parameterized, Type, %{country: "BR"}},
               nil
             ) == {:ok, nil}

      assert Ecto.Type.cast(
               {:parameterized, Type, %{country: "BR"}},
               "1"
             ) == {:error, [message: "not a number"]}

      assert Ecto.Type.cast(
               {:parameterized, Type, %{country: "BR"}},
               :invalid
             ) == :error
    end

    test "load" do
      number = String.trim_leading(to_string(@phone), "+")

      assert Ecto.Type.load({:parameterized, Type, nil}, number) == {:ok, @phone}
      assert Ecto.Type.load({:parameterized, Type, nil}, number) == {:ok, @phone}
      assert Ecto.Type.load({:parameterized, Type, nil}, nil) == {:ok, nil}
    end

    test "dump" do
      number = String.trim_leading(to_string(@phone), "+")

      assert Ecto.Type.dump({:parameterized, Type, nil}, @phone) == {:ok, number}
      assert Ecto.Type.dump({:parameterized, Type, nil}, nil) == {:ok, nil}
      assert Ecto.Type.dump({:parameterized, Type, nil}, :invalid) == :error
    end
  end
end
