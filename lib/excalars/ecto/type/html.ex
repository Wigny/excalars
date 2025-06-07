with :ok <- Code.ensure_all_loaded([Ecto, EasyHTML, Floki]) do
  defmodule Excalars.Ecto.Type.HTML do
    use Ecto.Type

    @impl true
    def type, do: :xml

    @impl true
    def cast(value) when is_struct(value, EasyHTML), do: {:ok, value}
    def cast(value) when is_binary(value), do: load(value)
    def cast(_value), do: :error

    @impl true
    def load(value) when is_binary(value), do: {:ok, EasyHTML.parse!(value)}

    @impl true
    def dump(value) when is_struct(value, EasyHTML), do: {:ok, Floki.raw_html(value.nodes)}
  end
end
