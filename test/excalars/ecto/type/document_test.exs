defmodule Excalars.Ecto.Type.DocumentTest do
  use ExUnit.Case, async: true

  import Excalars.Digits
  alias Excalars.Ecto.Type.Document, as: Type

  defmodule ID do
    @behaviour Excalars.Document

    defstruct [:digits]

    def new(digits), do: %__MODULE__{digits: digits}
    def valid?(_id), do: true
    def to_digits(id), do: id.digits
    def to_string(id), do: "ID#{id.digits}"
  end

  describe "document" do
    test "cast" do
      assert Ecto.Type.cast(
               {:parameterized, Type, %{type: ID}},
               "123"
             ) == {:ok, ID.new(~d[123])}

      assert Ecto.Type.cast(
               {:parameterized, Type, %{type: ID}},
               [1, 2, 3]
             ) == {:ok, ID.new(~d[123])}

      assert Ecto.Type.cast(
               {:parameterized, Type, %{type: ID}},
               ID.new(~d[123])
             ) == {:ok, ID.new(~d[123])}

      assert Ecto.Type.cast(
               {:parameterized, Type, %{type: ID}},
               nil
             ) == {:ok, nil}

      assert Ecto.Type.cast(
               {:parameterized, Type, %{type: ID}},
               :invalid
             ) == :error
    end

    test "load" do
      assert Ecto.Type.load(
               {:parameterized, Type, %{type: ID}},
               ~d[123]
             ) == {:ok, ID.new(~d[123])}

      assert Ecto.Type.load(
               {:parameterized, Type, %{}},
               nil
             ) == {:ok, nil}
    end

    test "dump" do
      assert Ecto.Type.dump(
               {:parameterized, Type, %{type: ID}},
               ID.new(~d[123])
             ) == {:ok, ~d[123]}

      assert Ecto.Type.dump(
               {:parameterized, Type, %{}},
               nil
             ) == {:ok, nil}

      assert Ecto.Type.dump(
               {:parameterized, Type, %{}},
               :invalid
             ) == :error
    end
  end
end
