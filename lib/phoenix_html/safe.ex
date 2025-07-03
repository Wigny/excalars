with :ok <- Code.ensure_all_loaded([Phoenix.HTML, Duration]) do
  defimpl Phoenix.HTML.Safe, for: Duration do
    defdelegate to_iodata(duration), to: @for, as: :to_string
  end
end

with :ok <- Code.ensure_all_loaded([Phoenix.HTML, EasyHTML]) do
  defimpl Phoenix.HTML.Safe, for: EasyHTML do
    def to_iodata(html) do
      html
      |> EasyHTML.to_html()
      |> Phoenix.HTML.Engine.encode_to_iodata!()
    end
  end
end
