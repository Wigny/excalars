defmodule Excalars.Phone do
  defstruct [:number, :country]

  defmodule ParsingError do
    defexception [:message]

    @type t :: %__MODULE__{message: binary}

    def new(fields), do: struct!(__MODULE__, fields)
  end

  @type t :: %__MODULE__{number: binary, country: binary}

  @spec new(number :: binary, country :: binary | nil) :: {:ok, t} | {:error, ParsingError.t()}
  def new(number, country \\ nil) do
    case ExPhoneNumber.parse(number, country) do
      {:ok, %{national_number: national_number, country_code: country_code}} ->
        number = Integer.to_string(national_number)
        country = ExPhoneNumber.Metadata.get_region_code_for_country_code(country_code)

        {:ok, struct!(__MODULE__, number: number, country: country)}

      {:error, reason} ->
        {:error, ParsingError.new(message: reason)}
    end
  end

  @spec valid?(phone :: t) :: boolean
  def valid?(phone) do
    {:ok, phone_number} = ExPhoneNumber.parse(phone.number, phone.country)

    ExPhoneNumber.is_valid_number?(phone_number)
  end

  @spec to_uri(phone :: t) :: URI.t()
  def to_uri(phone) do
    {:ok, phone_number} = ExPhoneNumber.parse(phone.number, phone.country)

    tel = ExPhoneNumber.format(phone_number, :rfc3966)
    URI.parse(tel)
  end

  defdelegate to_string(phone), to: String.Chars.Excalars.Phone

  defimpl String.Chars do
    def to_string(phone) do
      {:ok, phone_number} = ExPhoneNumber.parse(phone.number, phone.country)

      ExPhoneNumber.format(phone_number, :e164)
    end
  end

  defimpl Inspect do
    def inspect(phone, opts) do
      {:ok, phone_number} = ExPhoneNumber.parse(phone.number, phone.country)

      number = ExPhoneNumber.format(phone_number, :international)
      Inspect.BitString.inspect(number, opts)
    end
  end

  defimpl Phoenix.HTML.Safe do
    def to_iodata(phone) do
      {:ok, phone_number} = ExPhoneNumber.parse(phone.number, phone.country)

      ExPhoneNumber.format(phone_number, :national)
    end
  end
end
