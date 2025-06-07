defmodule Excalars.Ecto.Type.PhoneTest do
  use ExUnit.Case, async: true

  import Excalars.Phone, only: [sigil_P: 2]
  alias Excalars.Ecto.Type.Phone, as: Type

  @international_phone_type Ecto.ParameterizedType.init(Type, country: nil)
  @br_phone_type Ecto.ParameterizedType.init(Type, country: "BR")
  @us_phone_type Ecto.ParameterizedType.init(Type, country: "US")

  @phone ~P"(99) 9 9876-5432"BR

  test "cast" do
    assert Ecto.Type.cast(@international_phone_type, "+55 (99) 99876-5432") == {:ok, @phone}
    assert Ecto.Type.cast(@br_phone_type, "(99) 99876-5432") == {:ok, @phone}

    assert Ecto.Type.cast(@international_phone_type, "(99) 99876-5432") ==
             {:error, [message: "invalid country code"]}

    assert Ecto.Type.cast(@international_phone_type, @phone) == {:ok, @phone}

    assert Ecto.Type.cast(@us_phone_type, @phone) == :error

    assert Ecto.Type.cast(@br_phone_type, nil) == {:ok, nil}
    assert Ecto.Type.cast(@br_phone_type, "1") == {:error, [message: "not a number"]}
    assert Ecto.Type.cast(@br_phone_type, :invalid) == :error
  end

  test "load" do
    number = Excalars.Phone.to_e164(@phone)

    assert Ecto.Type.load(@international_phone_type, number) == {:ok, @phone}
    assert Ecto.Type.load(@international_phone_type, number) == {:ok, @phone}
    assert Ecto.Type.load(@international_phone_type, nil) == {:ok, nil}
  end

  test "dump" do
    number = Excalars.Phone.to_e164(@phone)

    assert Ecto.Type.dump(@international_phone_type, @phone) == {:ok, number}
    assert Ecto.Type.dump(@international_phone_type, nil) == {:ok, nil}
    assert Ecto.Type.dump(@international_phone_type, :invalid) == :error
  end
end
