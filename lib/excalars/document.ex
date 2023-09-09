defmodule Excalars.Document do
  alias Excalars.Digits

  @typep digits :: Digits.t()
  @typep document :: struct
  @typep exception :: %{
           :__struct__ => module,
           :__exception__ => true,
           :reason => binary,
           optional(atom) => any
         }

  @callback new(digits) :: {:ok, document} | {:error, exception}
  @callback to_digits(document) :: digits
  @callback to_string(document) :: binary

  @doc """
  Calculates the weighted sum of the digits using the given weights.
  """
  @spec weighted_sum(digits, weights :: Enumerable.t()) :: non_neg_integer
  def weighted_sum(digits, weights) do
    [digits, weights]
    |> Enum.zip()
    |> Enum.map(&Tuple.product/1)
    |> Enum.sum()
  end

  @doc """
  Calculates the modulo 11 of the given weighted sum.
  """
  @spec modulo11(sum :: integer) :: integer
  def modulo11(sum) do
    rem = rem(sum, 11)

    if rem < 2, do: 0, else: 11 - rem
  end
end
