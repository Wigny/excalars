defmodule Excalars.Document.CPF do
  alias Excalars.{Digits, Document}

  @behaviour Document

  defstruct [:base, :check_digits]

  defmodule Error do
    defexception [:reason]

    def new(fields), do: struct!(__MODULE__, fields)

    def message(%{reason: "invalid digits"}), do: "The CPF is invalid"
  end

  @impl true
  def new(digits) do
    {base, check_digits} = Enum.split(Digits.pad_leading(digits, 11), -2)

    if not Digits.duplicated?(base) and match?(^check_digits, check_digits(base)) do
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
  def to_string(cpf) do
    digits = to_digits(cpf)

    String.replace(Digits.to_string(digits), ~r/(\d{3})(\d{3})(\d{3})(\d{2})/, ~S"\1.\2.\3-\4")
  end

  # https://github.com/klawdyo/validation-br/blob/v.1.4.2/src/cpf.ts
  defp check_digits(base) do
    digit1 = Document.modulo11(Document.weighted_sum(base, 10..2))
    digit2 = Document.modulo11(Document.weighted_sum(base ++ [digit1], 11..2))

    [digit1, digit2]
  end

  defimpl String.Chars do
    defdelegate to_string(cnh), to: Excalars.Document.CPF
  end

  defimpl Inspect do
    def inspect(cpf, _opts) do
      Inspect.Algebra.concat(["#CPF<", to_string(cpf), ">"])
    end
  end

  if Code.ensure_loaded?(Phoenix.HTML.Safe) do
    defimpl Phoenix.HTML.Safe do
      def to_iodata(cpf) do
        to_string(cpf)
      end
    end
  end
end
