defmodule RFD.DSL do
  @moduledoc """
  Author an RFD as Elixir. The block builds an `RFD.Doc`, validates it against
  RFD 1000 while the file compiles, and exposes it as `__rfd__/0`.

      defmodule RFD2232 do
        use RFD.DSL

        rfd 2232, "RFD authoring as an Elixir DSL" do
          state :discussion
          flight_level :l2
          feature "one source file per RFD, the README and DETAILS rendered from it"
          scope "rfd_dsl/, every rfd/NNNN-slug/rfd.exs"

          decision \"\"\"
          ...
          \"\"\"

          problem \"\"\"
          ...
          \"\"\"

          references ["RFD 1000", "RFD 2177"]
          related "RFD 1000 (the shape), RFD 2177 (the register tag)."
          details "How the renderer is checked", \"\"\"
          ...
          \"\"\"
          drafted_by :ai
        end
      end

  A file that breaks the shape does not compile; the error names the rule.
  """

  defmacro __using__(_opts) do
    quote do
      import RFD.DSL, only: [rfd: 3]
    end
  end

  defmacro rfd(serial, title, do: block) do
    quote do
      Module.register_attribute(__MODULE__, :rfd_fields, accumulate: true)
      Module.register_attribute(__MODULE__, :rfd_details, accumulate: true)
      import RFD.DSL.Fields
      unquote(block)
      import RFD.DSL.Fields, only: []

      @rfd_doc RFD.DSL.build(unquote(serial), unquote(title), @rfd_fields, @rfd_details)
      def __rfd__, do: @rfd_doc
    end
  end

  @doc false
  def build(serial, title, fields, details) do
    fields = Enum.reverse(fields)

    dup =
      fields
      |> Enum.map(&elem(&1, 0))
      |> Enum.frequencies()
      |> Enum.filter(fn {_, n} -> n > 1 end)

    if dup != [],
      do:
        raise(
          ArgumentError,
          "RFD #{serial}: field given twice: #{inspect(Enum.map(dup, &elem(&1, 0)))}"
        )

    struct!(RFD.Doc, [serial: serial, title: title, details: Enum.reverse(details)] ++ fields)
    |> RFD.Doc.validate!()
  end

  defmodule Fields do
    @moduledoc false
    defmacro state(v), do: field(:state, v)
    defmacro feature(v), do: field(:feature, v)
    defmacro scope(v), do: field(:scope, v)
    defmacro flight_level(v), do: field(:flight_level, v)
    defmacro decision(v), do: field(:decision, v)
    defmacro problem(v), do: field(:problem, v)
    defmacro references(v), do: field(:references, v)
    defmacro related(v), do: field(:related, v)
    defmacro drafted_by(v), do: field(:drafted_by, v)

    defmacro details(heading, body) do
      quote do
        @rfd_details {unquote(heading), unquote(body)}
      end
    end

    defp field(name, v) do
      quote do
        @rfd_fields {unquote(name), unquote(v)}
      end
    end
  end
end
