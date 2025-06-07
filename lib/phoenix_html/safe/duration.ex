with :ok <- Code.ensure_all_loaded([Phoenix.HTML, Duration]) do
  defimpl Phoenix.HTML.Safe, for: Duration do
    defdelegate to_iodata(duration), to: Duration, as: :to_string
  end
end
