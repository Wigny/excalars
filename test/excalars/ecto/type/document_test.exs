defmodule Excalars.Ecto.Type.DocumentTest do
  use ExUnit.Case, async: true

  import Excalars.Digits

  defmodule ID do
    @behaviour Excalars.Document

    defstruct [:digits]

    def new(digits) do
      if length(digits) === 3 do
        {:ok, %__MODULE__{digits: digits}}
      else
        {:error, %{reason: "invalid length"}}
      end
    end

    def to_digits(id), do: id.digits
    def to_string(id), do: "ID#{id.digits}"
  end

  @document_type Ecto.ParameterizedType.init(Excalars.Ecto.Type.Document, as: ID)

  describe "document" do
    test "cast" do
      assert Ecto.Type.cast(@document_type, "123") == {:ok, %ID{digits: ~d[123]}}
      assert Ecto.Type.cast(@document_type, ~d[123]) == {:ok, %ID{digits: ~d[123]}}
      assert Ecto.Type.cast(@document_type, %ID{digits: ~d[123]}) == {:ok, %ID{digits: ~d[123]}}
      assert Ecto.Type.cast(@document_type, nil) == {:ok, nil}
      assert Ecto.Type.cast(@document_type, ~d[1234]) == {:error, message: "invalid length"}
      assert Ecto.Type.cast(@document_type, :invalid) == :error
    end

    test "load" do
      assert Ecto.Type.load(@document_type, "123") == {:ok, %ID{digits: ~d[123]}}
      assert Ecto.Type.load(@document_type, nil) == {:ok, nil}
    end

    test "dump" do
      assert Ecto.Type.dump(@document_type, %ID{digits: ~d[123]}) == {:ok, "123"}
      assert Ecto.Type.dump(@document_type, nil) == {:ok, nil}
      assert Ecto.Type.dump(@document_type, :invalid) == :error
    end
  end
end
