if Code.ensure_loaded?(Ecto) do
  defmodule Excalars.Ecto.Type.MillisecondDuration do
    use Ecto.Type

    defguardp is_duration(value) when is_struct(value, Duration)

    @impl true
    def type, do: :integer

    @impl true
    def cast(value) when is_integer(value), do: {:ok, to_duration(value)}
    def cast(value) when is_duration(value), do: {:ok, value}
    def cast(_value), do: :error

    @impl true
    def load(value) when is_integer(value), do: {:ok, to_duration(value)}

    @impl true
    def dump(value) when is_duration(value), do: {:ok, to_millisecond(value)}
    def dump(_value), do: :error

    @impl true
    def equal?(duration1, duration2) when is_duration(duration1) and is_duration(duration2) do
      to_millisecond(duration1) === to_millisecond(duration2)
    end

    def equal?(_duration1, _duration2) do
      false
    end

    defp to_duration(millisecond) do
      {second, millisecond} = div_rem(millisecond, 1000)
      {minute, second} = div_rem(second, 60)
      {hour, minute} = div_rem(minute, 60)
      {day, hour} = div_rem(hour, 24)
      {week, day} = div_rem(day, 7)
      microsecond = System.convert_time_unit(millisecond, :millisecond, :microsecond)

      Duration.new!(
        week: week,
        day: day,
        hour: hour,
        minute: minute,
        second: second,
        microsecond: {microsecond, if(microsecond == 0, do: 0, else: 3)}
      )
    end

    defp div_rem(num1, num2) do
      {div(num1, num2), rem(num1, num2)}
    end

    defp to_millisecond(duration) do
      to_timeout(duration)
    end
  end
end
