if Code.ensure_all_loaded([Ecto, Excalars.Phone]) do
  defmodule Excalars.Ecto.Type.Phone do
    @moduledoc """
    Custom `Ecto.Type` for handling `Excalars.Phone` structs as binary.

    On your schema, you can use this type on a `:string` field like this:

        field :phone, Excalars.Ecto.Type.Phone

    or if you want to allow only a specific country number

        field :phone, Excalars.Ecto.Type.Phone, country: "BR"

    """

    use Ecto.ParameterizedType
    alias Excalars.Phone

    defguardp is_phone(data) when is_struct(data, Phone)

    @impl true
    def type(_params), do: :string

    @impl true
    def init(opts), do: %{country: opts[:country]}

    @impl true
    def cast(number, %{country: country}) when is_binary(number) do
      case Phone.new(number, country) do
        {:ok, phone} -> {:ok, phone}
        {:error, error} -> {:error, message: error.reason}
      end
    end

    def cast(phone, %{country: nil}) when is_phone(phone) do
      {:ok, phone}
    end

    def cast(%{country: country} = phone, %{country: country}) when is_phone(phone) do
      {:ok, phone}
    end

    def cast(phone, _params) when is_nil(phone) do
      {:ok, nil}
    end

    def cast(_phone, _params) do
      :error
    end

    @impl true
    def load(number, _loader, _params) when is_binary(number) do
      case Phone.parse(<<?+, number::binary>>) do
        {:ok, _phone} = ok -> ok
        {:error, _error} -> :error
      end
    end

    def load(number, _loader, _params) when is_nil(number) do
      {:ok, nil}
    end

    @impl true
    def dump(phone, _dumper, _params) when is_phone(phone) do
      <<?+, number::binary>> = Phone.to_number(phone)
      {:ok, number}
    end

    def dump(phone, _dumper, _params) when is_nil(phone) do
      {:ok, nil}
    end

    def dump(_phone, _dumper, _params) do
      :error
    end
  end
end
