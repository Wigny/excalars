defmodule Excalars.Document do
  alias Excalars.Digits

  @typep digits :: Digits.t()
  @typep document :: struct
  @typep error :: %{
           :__struct__ => module,
           :__exception__ => true,
           :reason => binary,
           optional(atom) => any
         }

  @callback new(digits) :: {:ok, document} | {:error, error}
  @callback to_digits(document) :: digits
  @callback to_string(document) :: binary

  @spec modulus11(value :: integer) :: integer
  def modulus11(value) do
    rem = rem(value, 11)

    if rem < 2, do: 0, else: 11 - rem
  end
end
