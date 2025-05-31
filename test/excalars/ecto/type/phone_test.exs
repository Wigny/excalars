defmodule Excalars.Ecto.Type.PhoneTest do
  use ExUnit.Case, async: true

  alias Excalars.Ecto.Type.Phone, as: Type

  @phone_type Ecto.ParameterizedType.init(Type, [])
  @br_phone_type Ecto.ParameterizedType.init(Type, country: "BR")
  @us_phone_type Ecto.ParameterizedType.init(Type, country: "US")

  @phone %Excalars.Phone{number: 99_998_765_432, code: 55}

  describe "phone" do
    test "cast" do
      assert Ecto.Type.cast(@phone_type, "+55 (99) 99876-5432") == {:ok, @phone}

      assert Ecto.Type.cast(@br_phone_type, "(99) 99876-5432") == {:ok, @phone}

      assert Ecto.Type.cast(@phone_type, "(99) 99876-5432") ==
               {:error, [message: "invalid country code"]}

      assert Ecto.Type.cast(@phone_type, @phone) == {:ok, @phone}

      assert Ecto.Type.cast(@us_phone_type, @phone) == :error

      assert Ecto.Type.cast(@br_phone_type, nil) == {:ok, nil}

      assert Ecto.Type.cast(@br_phone_type, "1") == {:error, [message: "not a number"]}

      assert Ecto.Type.cast(@br_phone_type, :invalid) == :error
    end

    test "load" do
      number = String.trim_leading(Excalars.Phone.to_number(@phone), "+")

      assert Ecto.Type.load(@phone_type, number) == {:ok, @phone}
      assert Ecto.Type.load(@phone_type, number) == {:ok, @phone}
      assert Ecto.Type.load(@phone_type, nil) == {:ok, nil}
    end

    test "dump" do
      number = String.trim_leading(Excalars.Phone.to_number(@phone), "+")

      assert Ecto.Type.dump(@phone_type, @phone) == {:ok, number}
      assert Ecto.Type.dump(@phone_type, nil) == {:ok, nil}
      assert Ecto.Type.dump(@phone_type, :invalid) == :error
    end
  end
end
