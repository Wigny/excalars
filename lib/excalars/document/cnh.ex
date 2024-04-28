defmodule Excalars.Document.CNH do
  alias Excalars.{Digits, Document}

  @behaviour Document

  defstruct [:base, :check_digits]

  defmodule Error do
    defexception [:reason]

    def new(fields), do: struct!(__MODULE__, fields)

    def message(%{reason: "invalid digits"}), do: "The CNH is invalid"
  end

  @impl true
  def new(digits) do
    {base, check_digits} = Enum.split(Digits.pad_leading(digits, 11), -2)

    if not Digits.monodigit?(base) and match?(^check_digits, check_digits(base)) do
      {:ok, struct(__MODULE__, base: base, check_digits: check_digits)}
    else
      {:error, Error.new(reason: "invalid digits")}
    end
  end

  @impl true
  def to_digits(%{base: base, check_digits: check_digits}) do
    Enum.concat([base, check_digits])
  end

  @impl true
  def to_string(cnh) do
    digits = to_digits(cnh)
    Digits.to_string(digits)
  end

  # https://github.com/klawdyo/validation-br/blob/v.1.4.2/src/cnh.ts
  defp check_digits(base) do
    digit1 = Document.modulo11(Document.weighted_sum(base, 2..10))
    digit2 = Document.modulo11(Document.weighted_sum(base ++ [digit1], Enum.concat(3..11, [2])))

    [digit1, digit2]
  end

  defimpl Inspect do
    def inspect(cnh, _opts) do
      Inspect.Algebra.concat(["#Excalars.Document.CNH<", to_string(cnh), ">"])
    end
  end

  if Code.ensure_loaded?(Phoenix.HTML.Safe) do
    defimpl Phoenix.HTML.Safe do
      def to_iodata(cnh) do
        to_string(cnh)
      end
    end
  end
end
