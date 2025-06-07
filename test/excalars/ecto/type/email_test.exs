defmodule Excalars.Ecto.Type.EmailTest do
  use ExUnit.Case, async: true

  alias Excalars.Ecto.Type.Email

  test "cast" do
    assert Ecto.Type.cast(Email, "wigny@email.com") == {:ok, "wigny@email.com"}
    assert Ecto.Type.cast(Email, "wigny+batata@email.com") == {:ok, "wigny+batata@email.com"}
    assert Ecto.Type.cast(Email, "@email.com") == {:error, message: "malformed email address"}
    assert Ecto.Type.cast(Email, :invalid) == {:error, message: "invalid email address"}
    assert Ecto.Type.cast(Email, nil) == {:ok, nil}
  end

  test "load" do
    assert Ecto.Type.load(Email, "wigny@email.com") == {:ok, "wigny@email.com"}
    assert Ecto.Type.load(Email, "@email.com") == {:error, message: "malformed email address"}
    assert Ecto.Type.load(Email, :invalid) == {:error, message: "invalid email address"}
    assert Ecto.Type.load(Email, nil) == {:ok, nil}
  end

  test "dump" do
    assert Ecto.Type.dump(Email, "wigny@email.com") == {:ok, "wigny@email.com"}
    assert Ecto.Type.dump(Email, :invalid) == :error
    assert Ecto.Type.dump(Email, nil) == {:ok, nil}
  end
end
