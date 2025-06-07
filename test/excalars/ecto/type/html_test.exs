defmodule Excalars.Ecto.Type.HTMLTest do
  use ExUnit.Case, async: true

  import EasyHTML, only: [sigil_HTML: 2]
  alias Excalars.Ecto.Type.HTML

  test "cast" do
    assert Ecto.Type.cast(HTML, "<p>Hello world</p>") == {:ok, ~HTML[<p>Hello world</p>]}
    assert Ecto.Type.cast(HTML, ~HTML[<p>Hello world</p>]) == {:ok, ~HTML[<p>Hello world</p>]}
    assert Ecto.Type.cast(HTML, :invalid) == :error
    assert Ecto.Type.cast(HTML, nil) == {:ok, nil}
  end

  test "load" do
    assert Ecto.Type.load(HTML, "<span class=hint>hello</span>") ==
             {:ok, ~HTML[<span class="hint">hello</span>]}

    assert Ecto.Type.load(HTML, nil) == {:ok, nil}
  end

  test "dump" do
    assert Ecto.Type.dump(HTML, ~HTML[<span class="hint">hello</span>]) ==
             {:ok, ~s|<span class="hint">hello</span>|}

    assert Ecto.Type.dump(HTML, nil) == {:ok, nil}
  end
end
