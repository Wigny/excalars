with :ok <- Code.ensure_all_loaded([Phoenix.HTML, Duration]) do
  defimpl Phoenix.HTML.Safe, for: Duration do
    defdelegate to_iodata(duration), to: @for, as: :to_string
  end
end

with :ok <- Code.ensure_all_loaded([Phoenix.HTML, EasyHTML, Floki]) do
  defimpl Phoenix.HTML.Safe, for: EasyHTML do
    def to_iodata(%EasyHTML{nodes: html_tree}) do
      html_tree
      |> Floki.raw_html(encode: false)
      |> Phoenix.HTML.Engine.encode_to_iodata!()
    end
  end
end
