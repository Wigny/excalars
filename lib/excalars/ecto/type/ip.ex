if Code.ensure_all_loaded([Ecto, Postgrex]) do
  defmodule Excalars.Ecto.Type.IP do
    use Ecto.Type

    @impl true
    def type(), do: :inet

    @impl true

    def cast(address) when is_binary(address) do
      case :inet.parse_address(to_charlist(address)) do
        {:ok, _address} = ok -> ok
        {:error, :einval} -> :error
      end
    end

    def cast(address) do
      if :inet.is_ip_address(address) do
        {:ok, address}
      else
        :error
      end
    end

    @impl true
    def load(inet) when is_struct(inet, Postgrex.INET) do
      {:ok, inet.address}
    end

    @impl true
    def dump(address) do
      if :inet.is_ip_address(address) do
        {:ok, %Postgrex.INET{address: address}}
      else
        :error
      end
    end
  end
end
