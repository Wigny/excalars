defmodule Excalars.Document.CPFTest do
  use ExUnit.Case, async: true

  import Excalars.Digits
  alias Excalars.Document.CPF

  @cpf %CPF{base: ~d[045434132], check_digits: ~d[61]}

  describe "cpf" do
    test "new/1 returns a document struct validating the digits" do
      assert {:ok, @cpf} = CPF.new(~d[4543413261])
      assert {:error, %CPF.Error{reason: "invalid digits"}} = CPF.new(~d[4543413262])
    end

    test "to_digits/1 returns the document digits" do
      assert ~d[04543413261] = CPF.to_digits(@cpf)
    end

    test "to_string/1 returns the document string representation" do
      assert "045.434.132-61" = CPF.to_string(@cpf)
    end
  end
end
