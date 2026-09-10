# Copyright (c) 2026 K. S. Ernest (iFire) Lee
# SPDX-License-Identifier: MIT

defmodule RFD.Corpus do
  @moduledoc """
  The contract every register-like corpus answers, and the mixin that supplies it.

  `SERIALS.exs`, `SERIALS-vsekai-fabric.exs` and `ESCAPES.exs` are all registers
  of records that differ only in what a record is. Before this they were reached
  one file at a time, and a question was answered by globbing or by naming a
  path — which is how `grep 2235 SERIALS.exs` returned nothing and was read as
  "no register names this serial" while the serial sat in the other register.

  A caller should not be able to ask about one corpus. `RFD.Corpora` is the
  facade that answers across all of them; this is the contract it dispatches on.

  Mixed in rather than inherited: `use RFD.Corpus, kind: :serials, via: :__register__`
  injects `__corpus__/0` and declares the behaviour, leaving the module's own
  accessor untouched for existing callers.
  """

  @type entry :: map()
  @type t :: %{kind: atom(), name: String.t(), entries: [entry()]}

  @callback __corpus__() :: t()

  defmacro __using__(opts) do
    kind = Keyword.fetch!(opts, :kind)
    via = Keyword.fetch!(opts, :via)
    entries = Keyword.fetch!(opts, :entries)

    quote do
      @behaviour RFD.Corpus

      @impl RFD.Corpus
      def __corpus__ do
        doc = apply(__MODULE__, unquote(via), [])

        %{
          kind: unquote(kind),
          name: Map.get(doc, :name) || to_string(__MODULE__),
          entries: Map.fetch!(doc, unquote(entries))
        }
      end
    end
  end
end
