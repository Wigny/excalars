if Code.ensure_loaded?(ExPhoneNumber) do
  defmodule Excalars.Phone do
    @moduledoc """
    A representation of a phone number.

    This module is a tiny wrapper around the `ExPhoneNumber` library, providing a clear and simple
    API to deal with creating, parsing and validating phone numbers. To have this wrapper
    available for use, you are required to add the `ex_phone_number` dependency to your project
    (check the [`ExPhoneNumber` installation documentation](https://hexdocs.pm/ex_phone_number/readme.html#installation)).
    """

    @type t :: %__MODULE__{code: non_neg_integer, number: non_neg_integer}
    defstruct [:code, :number]

    defmodule Error do
      @moduledoc false

      alias ExPhoneNumber.Constants.ErrorMessages

      @type t :: %__MODULE__{reason: binary}
      defexception [:reason]

      def new(fields), do: struct!(__MODULE__, fields)

      def message(%{reason: "invalid country code"}), do: ErrorMessages.invalid_country_code()
      def message(%{reason: "not a number"}), do: ErrorMessages.not_a_number()
      def message(%{reason: "too short after IDD"}), do: ErrorMessages.too_short_after_idd()
      def message(%{reason: "too short"}), do: ErrorMessages.too_short_nsn()
      def message(%{reason: "too long"}), do: ErrorMessages.too_long()
      def message(%{reason: "invalid length"}), do: "The phone number has not a valid length"
    end

    def sigil_P(number, ~c""), do: new!(number, nil)
    def sigil_P(number, country), do: new!(number, Kernel.to_string(country))

    @doc """
    Creates a new `Phone` struct from given local number and country code.

    ## Examples

        iex> Phone.new("+44 (020) 1234 5678")
        {:ok, %Excalars.Phone{code: 44, number: 02_012_345_678}}

        iex> Phone.new("(11) 98765-4321", "BR")
        {:ok, %Excalars.Phone{code: 55, number: 11_987_654_321}}

        iex> Phone.new("9876", "BR")
        {:error, Phone.Error.new(reason: "too short")}
    """
    @spec new(number :: binary, country :: binary | nil) :: {:ok, t} | {:error, Error.t()}
    def new(number, country \\ nil) do
      with {:ok, phone_number} <- parse_phone_number(number, country),
           :ok <- validate_number_possible(phone_number),
           :ok <- validate_match_country(phone_number, country) do
        {:ok, %__MODULE__{code: phone_number.country_code, number: phone_number.national_number}}
      end
    end

    @doc """
    Same as `new/2`, but raises an exception if the phone number is invalid.

    ## Examples

        iex> Phone.new!("+44 (020) 1234 5678")
        %Excalars.Phone{code: 44, number: 02_012_345_678}

        iex> Phone.new!("(11) 98765-4321", "BR")
        %Excalars.Phone{code: 55, number: 11_987_654_321}

        iex> Phone.new!("invalid", "BR")
        ** (Excalars.Phone.Error) The string supplied did not seem to be a phone number
    """
    @spec new!(number :: binary, country :: binary | nil) :: t
    def new!(number, country \\ nil) do
      case new(number, country) do
        {:ok, phone} -> phone
        {:error, error} -> raise error
      end
    end

    @doc """
    Converts the given `Phone` to an [E.164](https://wikipedia.org/wiki/E.164) formatted string.

    ## Examples

        iex> phone = Phone.new!("+55 11 98765-4321")
        ...> Phone.to_e164(phone)
        "+5511987654321"
    """
    @spec to_e164(phone :: t) :: binary
    def to_e164(phone) do
      ExPhoneNumber.format(to_phone_number(phone), :e164)
    end

    @doc """
    Converts the `Phone` into a formatted phone number string.

    ## Examples

        iex> phone = Phone.new!("11987654321", "BR")
        ...> Phone.to_string(phone)
        "+55 11 98765-4321"
    """
    @spec to_string(phone :: t) :: binary
    def to_string(phone) do
      ExPhoneNumber.format(to_phone_number(phone), :international)
    end

    @doc """
    Converts the given `Phone` into the `URI` struct.

    ## Examples

        iex> phone = Phone.new!("+55 11 98765-4321")
        ...> Phone.to_uri(phone)
        %URI{scheme: "tel", path: "+55-11-98765-4321"}
    """
    @spec to_uri(phone :: t) :: URI.t()
    def to_uri(phone) do
      tel = ExPhoneNumber.format(to_phone_number(phone), :rfc3966)
      URI.parse(tel)
    end

    defp parse_phone_number(number, country) do
      with {:error, message} <- ExPhoneNumber.parse(number, country) do
        {:error, Error.new(reason: to_error_reason(message))}
      end
    end

    defp to_phone_number(phone) do
      %ExPhoneNumber.Model.PhoneNumber{country_code: phone.code, national_number: phone.number}
    end

    defp validate_number_possible(phone_number) do
      case ExPhoneNumber.Validation.is_possible_number_with_reason?(phone_number) do
        :is_possible -> :ok
        reason -> {:error, Error.new(reason: to_error_reason(reason))}
      end
    end

    defp validate_match_country(_phone_number, nil) do
      :ok
    end

    defp validate_match_country(%{country_code: country_code}, country) do
      if match?(^country, ExPhoneNumber.Metadata.get_region_code_for_country_code(country_code)) do
        :ok
      else
        {:error, Error.new(reason: "invalid country code")}
      end
    end

    defp to_error_reason(message) when is_binary(message) do
      import ExPhoneNumber.Constants.ErrorMessages

      cond do
        message === invalid_country_code() -> "invalid country code"
        message === not_a_number() -> "not a number"
        message === too_short_after_idd() -> "too short after IDD"
        message === too_short_nsn() -> "too short"
        message === too_long() -> "too long"
      end
    end

    defp to_error_reason(reason) when is_atom(reason) do
      case reason do
        :invalid_country_code -> "invalid country code"
        :too_short -> "too short"
        :too_long -> "too long"
        :invalid_length -> "invalid length"
      end
    end

    defimpl String.Chars do
      defdelegate to_string(phone), to: Excalars.Phone
    end

    defimpl Inspect do
      def inspect(phone, _opts) do
        Inspect.Algebra.concat(["#Excalars.Phone<", to_string(phone), ">"])
      end
    end

    if Code.ensure_loaded?(Phoenix.HTML) do
      defimpl Phoenix.HTML.Safe do
        defdelegate to_iodata(phone), to: @for, as: :to_string
      end
    end
  end
end
