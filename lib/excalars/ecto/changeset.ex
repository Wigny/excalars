if Code.ensure_loaded?(Ecto) do
  defmodule Excalars.Ecto.Changeset do
    @moduledoc """
    Set of Changeset validation functions for Excalars.
    """

    import Ecto.Changeset

    @doc """
    Validates the given field is a valid `Excalars.Phone`.
    """
    def validate_phone(changeset, field) do
      validate_change(changeset, field, fn ^field, phone ->
        if Excalars.Phone.valid?(phone) do
          []
        else
          [{field, "is invalid"}]
        end
      end)
    end

    @doc """
    Validates the given field is a valid `URI`.
    """
    def validate_uri(changeset, field) do
      validate_change(changeset, field, fn ^field, uri ->
        cond do
          is_nil(uri.scheme) ->
            [{field, "is missing scheme"}]

          is_nil(uri.host) ->
            [{field, "is missing host"}]

          match?({:error, _posix}, :inet.gethostbyname(to_charlist(uri.host))) ->
            [{field, "has invalid host"}]

          :otherwise ->
            []
        end
      end)
    end
  end
end
