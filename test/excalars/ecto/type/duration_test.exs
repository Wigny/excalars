defmodule Excalars.Ecto.Type.DurationTest do
  use ExUnit.Case

  alias Excalars.Ecto.Type.Duration

  @interval %Postgrex.Interval{months: 1, days: 1, secs: 30, microsecs: 0}
  @duration Timex.Duration.parse!("P1M1DT30S")

  describe "duration" do
    test "cast" do
      assert Ecto.Type.cast(Duration, @interval) == {:ok, @duration}
      assert Ecto.Type.cast(Duration, @duration) == {:ok, @duration}
      assert Ecto.Type.cast(Duration, :invalid) == :error
    end

    test "load" do
      assert Ecto.Type.load(Duration, @interval) == {:ok, @duration}
    end

    test "dump" do
      interval = %Postgrex.Interval{microsecs: Timex.Duration.to_microseconds(@duration)}

      assert Ecto.Type.dump(Duration, @duration) == {:ok, interval}
      assert Ecto.Type.dump(Duration, :invalid) == :error
    end

    test "equal?" do
      assert Ecto.Type.equal?(Duration, @duration, Timex.Duration.parse!("P31DT30S"))
    end
  end
end
