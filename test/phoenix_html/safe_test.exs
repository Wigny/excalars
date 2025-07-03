defmodule Phoenix.HTML.SafeTest do
  use ExUnit.Case, async: true

  alias Phoenix.HTML.Safe

  test "impl for `Duration`" do
    duration =
      Duration.new!(
        year: 1,
        month: 2,
        week: 3,
        day: 5,
        hour: 6,
        minute: 7,
        second: 8,
        microsecond: {9_000_00, 6}
      )

    assert Safe.to_iodata(duration) == "1a 2mo 3wk 5d 6h 7min 8.900000s"
  end

  test "impl for `EasyHTML`" do
    html_string = ~s(<div class="wrapper">10 > 5</div>)

    assert Safe.to_iodata(EasyHTML.from_document(html_string)) ==
             with({:safe, iodata} <- Phoenix.HTML.html_escape(html_string), do: iodata)
  end

  test "impl for `Excalars.Phone" do
    phone = Excalars.Phone.new!("+5599999999999")

    assert Safe.to_iodata(phone) == "+55 99 99999-9999"
  end
end
