with :ok <- Code.ensure_all_loaded([Phoenix.HTML, EasyHTML, Floki]) do
  defimpl Phoenix.HTML.Safe, for: EasyHTML do
    def to_iodata(%EasyHTML{nodes: html_tree}) do
      html_tree
      |> Floki.raw_html()
      |> Phoenix.HTML.Engine.html_escape()
    end
  end
end
