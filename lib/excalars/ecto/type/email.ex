with :ok <- Code.ensure_all_loaded([Ecto, ExEmail]) do
  defmodule Excalars.Ecto.Type.Email do
    use Ecto.Type

    @impl true
    def type, do: :string

    @impl true
    def cast(email) do
      with :ok <- validate(email), do: {:ok, email}
    end

    @impl true
    def load(email) do
      with :ok <- validate(email), do: {:ok, email}
    end

    @impl true
    def dump(email) when is_binary(email), do: {:ok, email}
    def dump(_email), do: :error

    defp validate(email) when is_binary(email) do
      with {:error, _error} <- ExEmail.validate(email) do
        {:error, message: "malformed email address"}
      end
    end

    defp validate(_email) do
      {:error, message: "invalid email address"}
    end
  end
end
