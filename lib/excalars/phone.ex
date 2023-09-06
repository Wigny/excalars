defmodule Excalars.Phone do
  @moduledoc """
  A representation of a phone number.

  This module is a tiny wrapper around the `ExPhoneNumber` library, providing a clear and simple
  API to deal with creating, parsing and validating phone numbers.
  """

  defstruct [:number, :country]

  @type t :: %__MODULE__{number: binary, country: binary}

  defmodule Error do
    alias ExPhoneNumber.Constants.ErrorMessages

    defexception [:reason]

    @type t :: %__MODULE__{reason: binary}

    def new(fields), do: struct!(__MODULE__, fields)

    def message(%{reason: "invalid country code"}), do: ErrorMessages.invalid_country_code()
    def message(%{reason: "not a number"}), do: ErrorMessages.not_a_number()
    def message(%{reason: "too short after IDD"}), do: ErrorMessages.too_short_after_idd()
    def message(%{reason: "too short"}), do: ErrorMessages.too_short_nsn()
    def message(%{reason: "too long"}), do: ErrorMessages.too_long()
    def message(%{reason: "invalid length"}), do: "The phone number has not a valid length"
  end

  @spec new(number :: binary) :: {:ok, t} | {:error, Error.t()}
  def new(<<?+, _e164::binary>> = number) do
    new(number, nil)
  end

  @spec new(number :: binary, country :: binary | nil) :: {:ok, t} | {:error, Error.t()}
  @doc """
  Creates a new [Phone struct](`t:t/0`) from the given number and country code.
  """
  def new(number, country) do
    with {:ok, phone} <- parse(number, country),
         :ok <- validate_number_possible(phone),
         :ok <- validate_match_country(phone, country) do
      {:ok, phone}
    end
  end

  @spec new!(number :: binary) :: t
  def new!(<<?+, _e164::binary>> = number) do
    new!(number, nil)
  end

  @spec new!(number :: binary, country :: binary | nil) :: t
  @doc """
  Similar to `new!/2` but raises an exception if the phone number is invalid.
  """
  def new!(number, country) do
    case new(number, country) do
      {:ok, phone} -> phone
      {:error, error} -> raise error
    end
  end

  @spec parse(number :: binary, country :: binary | nil) :: {:ok, t} | {:error, Error.t()}
  @doc """
  Parses a phone number and it's country code into the [Phone struct](`t:t/0`) without futher
  validations.
  """
  def parse(number, country \\ nil) do
    case ExPhoneNumber.parse(number, country) do
      {:ok, phone_number} -> {:ok, from_phone_number(phone_number)}
      {:error, message} -> {:error, Error.new(reason: to_error_reason(message))}
    end
  end

  @spec valid?(phone :: t) :: boolean
  @doc """
  Checks whether the [Phone](`t:t/0`) has a possible valid number.
  """
  def valid?(phone) do
    phone_number = to_phone_number(phone)

    ExPhoneNumber.is_possible_number?(phone_number) and
      ExPhoneNumber.is_valid_number?(phone_number)
  end

  @spec to_string(phone :: t, format :: :e164 | :rfc3966 | :international | :national) :: binary
  @doc """
  Converts the [Phone](`t:t/0`) into a phone number string according the given format.
  """
  def to_string(phone, format \\ :e164) do
    ExPhoneNumber.format(to_phone_number(phone), format)
  end

  @spec to_uri(phone :: t) :: URI.t()
  @doc """
  Converts the given [Phone](`t:t/0`) into the URI struct.
  """
  def to_uri(phone) do
    URI.parse(to_string(phone, :rfc3966))
  end

  defp from_phone_number(phone_number) do
    country = ExPhoneNumber.Metadata.get_region_code_for_country_code(phone_number.country_code)

    %__MODULE__{number: phone_number.national_number, country: country}
  end

  defp to_phone_number(phone) do
    country_code = ExPhoneNumber.Metadata.get_country_code_for_region_code(phone.country)

    %ExPhoneNumber.Model.PhoneNumber{national_number: phone.number, country_code: country_code}
  end

  defp validate_number_possible(phone) do
    case ExPhoneNumber.Validation.is_possible_number_with_reason?(to_phone_number(phone)) do
      :is_possible -> :ok
      reason -> {:error, Error.new(reason: to_error_reason(reason))}
    end
  end

  defp validate_match_country(_phone, nil) do
    :ok
  end

  defp validate_match_country(%{country: country}, country) do
    :ok
  end

  defp validate_match_country(_phone, _country) do
    {:error, Error.new(reason: "invalid country code")}
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
      Inspect.Algebra.concat(["#Phone<", Excalars.Phone.to_string(phone, :international), ">"])
    end
  end

  if Code.ensure_loaded?(Phoenix.HTML.Safe) do
    defimpl Phoenix.HTML.Safe do
      def to_iodata(phone) do
        Excalars.Phone.to_string(phone, :national)
      end
    end
  end
end
