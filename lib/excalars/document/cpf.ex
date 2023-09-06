defmodule Excalars.Document.CPF do
  alias Excalars.{Digits, Document}

  @behaviour Document

  defstruct [:base, :check_digits]

  @impl true
  def new(digits) do
    {base, check_digits} = Enum.split(Digits.pad_leading(digits, 11), -2)
    struct(__MODULE__, base: base, check_digits: check_digits)
  end

  # https://github.com/klawdyo/validation-br/blob/v.1.4.2/src/cpf.ts
  @impl true
  def valid?(%{base: base, check_digits: check_digits}) do
    digit1 = Document.modulus11(Digits.dot_product(base, Enum.to_list(10..2)))
    digit2 = Document.modulus11(Digits.dot_product(base ++ [digit1], Enum.to_list(11..2)))

    not Digits.duplicated?(base) and match?(^check_digits, [digit1, digit2])
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

  defimpl Inspect do
    def inspect(cpf, _opts) do
      Inspect.Algebra.concat(["#CPF<", Excalars.Document.CPF.to_string(cpf), ">"])
    end
  end

  if Code.ensure_loaded?(Phoenix.HTML.Safe) do
    defimpl Phoenix.HTML.Safe do
      def to_iodata(cpf) do
        Excalars.Document.CPF.to_string(cpf)
      end
    end
  end
end
