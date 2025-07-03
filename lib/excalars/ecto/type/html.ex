with :ok <- Code.ensure_all_loaded([Ecto, EasyHTML]) do
  defmodule Excalars.Ecto.Type.HTML do
    use Ecto.Type

    @impl true
    def type, do: :xml

    @impl true
    def cast(value) when is_struct(value, EasyHTML), do: {:ok, value}
    def cast(value) when is_binary(value), do: load(value)
    def cast(_value), do: :error

    @impl true
    def load(value) when is_binary(value), do: {:ok, EasyHTML.from_document(value)}

    @impl true
    def dump(value) when is_struct(value, EasyHTML), do: {:ok, EasyHTML.to_tree(value.nodes)}
  end
end
