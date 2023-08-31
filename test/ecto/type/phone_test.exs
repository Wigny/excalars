defmodule Excalars.Ecto.Type.PhoneTest do
  use ExUnit.Case

  alias Excalars.Ecto.Type.Phone, as: Type

  @phone %Excalars.Phone{number: "99998765432", country: "BR"}

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
             ) == {:error, [message: "Invalid country calling code"]}

      assert Ecto.Type.cast(
               {:parameterized, Type, %{country: "BR"}},
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
             ) == {:error, [message: "The string supplied did not seem to be a phone number"]}

      assert Ecto.Type.cast(
               {:parameterized, Type, %{country: "BR"}},
               :invalid
             ) == :error
    end

    test "load" do
      assert Ecto.Type.load(
               {:parameterized, Type, %{country: "BR"}},
               to_string(@phone)
             ) == {:ok, @phone}

      assert Ecto.Type.load(
               {:parameterized, Type, %{country: nil}},
               to_string(@phone)
             ) == {:ok, @phone}

      assert Ecto.Type.load(
               {:parameterized, Type, %{country: "BR"}},
               nil
             ) == {:ok, nil}
    end

    test "dump" do
      assert Ecto.Type.dump(
               {:parameterized, Type, nil},
               @phone
             ) == {:ok, String.trim_leading(to_string(@phone), "+")}

      assert Ecto.Type.dump(
               {:parameterized, Type, nil},
               @phone
             ) == {:ok, String.trim_leading(to_string(@phone), "+")}

      assert Ecto.Type.dump(
               {:parameterized, Type, nil},
               nil
             ) == {:ok, nil}

      assert Ecto.Type.dump(
               {:parameterized, Type, nil},
               :invalid
             ) == :error
    end
  end
end
