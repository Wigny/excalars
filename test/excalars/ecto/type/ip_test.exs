defmodule Excalars.Ecto.Type.IPTest do
  use ExUnit.Case, async: true

  alias Excalars.Ecto.Type.IP

  @ipv4 {192, 168, 1, 100}

  describe "duration" do
    test "cast" do
      assert Ecto.Type.cast(IP, "192.168.1.100") == {:ok, @ipv4}
      assert Ecto.Type.cast(IP, @ipv4) == {:ok, @ipv4}
      assert Ecto.Type.cast(IP, {300, 500, 150, 1200}) == :error
    end

    test "load" do
      assert Ecto.Type.load(IP, %Postgrex.INET{address: @ipv4}) == {:ok, @ipv4}
    end

    test "dump" do
      assert Ecto.Type.dump(IP, @ipv4) == {:ok, %Postgrex.INET{address: @ipv4}}
      assert Ecto.Type.dump(IP, :invalid) == :error
    end
  end
end
