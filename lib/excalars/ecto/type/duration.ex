if Code.ensure_all_loaded([Ecto, Postgrex, Timex]) do
  defmodule Excalars.Ecto.Type.Duration do
    use Ecto.Type

    alias Postgrex.Interval
    alias Timex.Duration

    defguardp is_duration(value) when is_struct(value, Duration)
    defguardp is_interval(value) when is_struct(value, Interval)

    @impl true
    def type, do: :interval

    @impl true
    def cast(value) when is_interval(value), do: {:ok, from_interval(value)}
    def cast(value) when is_duration(value), do: {:ok, value}
    def cast(_value), do: :error

    @impl true
    def load(value) when is_interval(value), do: {:ok, from_interval(value)}

    @impl true
    def dump(value) when is_duration(value), do: {:ok, to_interval(value)}
    def dump(_value), do: :error

    @impl true
    def equal?(duration1, duration2) do
      left = Duration.to_microseconds(duration1)
      right = Duration.to_microseconds(duration2)

      left == right
    end

    defp from_interval(interval) do
      clock = {(interval.months * 30 + interval.days) * 24, 0, interval.secs, interval.microsecs}

      Duration.from_clock(clock)
    end

    defp to_interval(duration) do
      microseconds = Duration.to_microseconds(duration)

      %Interval{microsecs: microseconds}
    end
  end
end
