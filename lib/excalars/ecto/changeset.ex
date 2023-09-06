if Code.ensure_loaded(Ecto) do
  defmodule Excalars.Ecto.Changeset do
    import Ecto.Changeset

    def validate_document(changeset, field) do
      validate_change(changeset, field, fn ^field, document ->
        if apply(document.__struct__, :valid?, [document]) do
          []
        else
          [{field, "is invalid"}]
        end
      end)
    end

    def validate_phone(changeset, field) do
      validate_change(changeset, field, fn ^field, phone ->
        if Excalars.Phone.valid?(phone) do
          []
        else
          [{field, "is invalid"}]
        end
      end)
    end

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
