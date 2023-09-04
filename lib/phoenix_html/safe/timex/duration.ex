if Code.ensure_all_loaded([Phoenix.HTML, Timex]) do
  defimpl Phoenix.HTML.Safe, for: Timex.Duration do
    alias Timex.Format.Duration.Formatter

    def to_iodata(duration) do
      Formatter.lformat(duration, Gettext.get_locale(), :humanized)
    end
  end
end
