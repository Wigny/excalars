defmodule Excalars.Ecto.Type.MillisecondDurationTest do
  use ExUnit.Case, async: true

  alias Excalars.Ecto.Type.MillisecondDuration

  @duration Duration.from_iso8601!("P3W1DT30.500000S")
  @milliseconds to_timeout(@duration)

  describe "duration" do
    test "cast" do
      assert Ecto.Type.cast(MillisecondDuration, @milliseconds) == {:ok, @duration}
      assert Ecto.Type.cast(MillisecondDuration, @duration) == {:ok, @duration}
      assert Ecto.Type.cast(MillisecondDuration, :invalid) == :error
    end

    test "load" do
      assert Ecto.Type.load(MillisecondDuration, @milliseconds) == {:ok, @duration}
    end

    test "dump" do
      assert Ecto.Type.dump(MillisecondDuration, @duration) == {:ok, @milliseconds}
      assert Ecto.Type.dump(MillisecondDuration, :invalid) == :error
    end

    test "equal?" do
      assert Ecto.Type.equal?(
               MillisecondDuration,
               @duration,
               Duration.from_iso8601!("P22DT30.5S")
             )
    end
  end
end
