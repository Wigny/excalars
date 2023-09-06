defmodule Excalars.Ecto.ChangesetTest do
  use ExUnit.Case, async: true

  import Ecto.Changeset
  import Excalars.Ecto.Changeset

  alias Excalars.Document.CPF
  alias Excalars.Ecto.Type

  defmodule User do
    use Ecto.Schema

    schema "users" do
      field :cpf, Type.Document, as: CPF
      field :phone, Type.Phone, country: "BR"
      field :avatar, Type.URI
    end
  end

  describe "validate_document/2" do
    test "with valid document" do
      changeset =
        %User{}
        |> cast(%{cpf: "045.434.132-61"}, [:cpf])
        |> validate_document(:cpf)

      assert changeset.valid?
    end

    test "with invalid document" do
      changeset =
        %User{}
        |> cast(%{cpf: "045.434.132-62"}, [:cpf])
        |> validate_document(:cpf)

      refute changeset.valid?
      assert changeset.errors == [cpf: {"is invalid", []}]
    end
  end

  describe "validate_phone/2" do
    test "with valid phone" do
      changeset =
        %User{}
        |> cast(%{phone: "(11) 99999-9999"}, [:phone])
        |> validate_phone(:phone)

      assert changeset.valid?
    end

    test "with invalid phone" do
      changeset =
        %User{}
        |> cast(%{phone: "(11) 999-999"}, [:phone])
        |> validate_phone(:phone)

      refute changeset.valid?
      assert changeset.errors == [phone: {"is invalid", []}]
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
