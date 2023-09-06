defmodule Excalars.Ecto.Type.URITest do
  use ExUnit.Case, async: true

  @uri %URI{scheme: "http", host: "example.com", port: 80}

  describe "uri" do
    test "cast" do
      assert Ecto.Type.cast(Excalars.Ecto.Type.URI, to_string(@uri)) == {:ok, @uri}
      assert Ecto.Type.cast(Excalars.Ecto.Type.URI, @uri) == {:ok, @uri}
      assert Ecto.Type.cast(Excalars.Ecto.Type.URI, nil) == {:ok, nil}
      assert Ecto.Type.cast(Excalars.Ecto.Type.URI, :invalid) == :error
    end

    test "load" do
      assert Ecto.Type.load(Excalars.Ecto.Type.URI, to_string(@uri)) == {:ok, @uri}
      assert Ecto.Type.load(Excalars.Ecto.Type.URI, nil) == {:ok, nil}
    end

    test "dump" do
      assert Ecto.Type.dump(Excalars.Ecto.Type.URI, @uri) == {:ok, to_string(@uri)}
      assert Ecto.Type.dump(Excalars.Ecto.Type.URI, nil) == {:ok, nil}
      assert Ecto.Type.dump(Excalars.Ecto.Type.URI, :invalid) == :error
    end
  end
end
