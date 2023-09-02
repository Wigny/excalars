defmodule Excalars.Ecto.ChangesetTest do
  use ExUnit.Case
  import Ecto.Changeset
  import Excalars.Ecto.Changeset

  defmodule User do
    use Ecto.Schema

    schema "users" do
      field :avatar, Excalars.Ecto.Type.URI
    end
  end

  describe "validate_uri/2" do
    test "with valid URI" do
      changeset =
        %User{}
        |> cast(%{avatar: "https://example.com/avatar.png"}, [:avatar])
        |> validate_uri(:avatar)

      assert changeset.valid?
    end

    test "with missing scheme" do
      changeset =
        %User{}
        |> cast(%{avatar: "example.com/avatar.png"}, [:avatar])
        |> validate_uri(:avatar)

      refute changeset.valid?
      assert changeset.errors == [avatar: {"is missing scheme", []}]
    end

    test "with missing host" do
      changeset =
        %User{}
        |> cast(%{avatar: "https:/avatar.png"}, [:avatar])
        |> validate_uri(:avatar)

      refute changeset.valid?
      assert changeset.errors == [avatar: {"is missing host", []}]
    end

    test "with invalid host" do
      changeset =
        %User{}
        |> cast(%{avatar: URI.parse("https://example.com invalid/avatar.png")}, [:avatar])
        |> validate_uri(:avatar)

      refute changeset.valid?
      assert changeset.errors == [avatar: {"has invalid host", []}]
    end
  end
end
