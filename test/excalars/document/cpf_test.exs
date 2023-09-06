defmodule Excalars.Document.CPFTest do
  use ExUnit.Case, async: true

  import Excalars.Digits
  alias Excalars.Document.CPF

  describe "cpf" do
    test "new/1 returns a document struct" do
      assert %{base: ~d[045434132], check_digits: ~d[61]} = CPF.new(~d[4543413261])
    end

    test "valid?/1 checks the document check digits" do
      assert CPF.valid?(CPF.new(~d[04543413261]))
      refute CPF.valid?(CPF.new(~d[04543413262]))
    end

    test "to_digits/1 returns the document digits" do
      assert ~d[04543413261] = CPF.to_digits(CPF.new(~d[04543413261]))
    end

    test "to_string/1 returns the document string representation" do
      assert "045.434.132-61" = CPF.to_string(CPF.new(~d[04543413261]))
    end
  end
end
