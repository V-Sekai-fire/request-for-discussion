defmodule RFD.Doc do
  @moduledoc """
  One RFD as data, the shape RFD 1000 gives it, and the three renderings of it.

  The README rendering is what `scripts/check-rfd-structure.py` and
  `scripts/render_site.py` read: CommonMark, `# RFD NNNN: title`, the metadata
  lines State / Feature / Scope in that order, then the spine Decision, Problem,
  References, Related, then the attestation sentence. `render_site.py` turns that
  README into the `index.md` Quarto lists, so a README this module writes is a
  Quarto document by construction. `qmd/1` writes the same document with YAML
  front matter for a Quarto project that has no `render_site.py` in front of it.
  """

  @states ~w(abandoned committed discussion ideation moved prediscussion published)a
  @no_decision_states [:moved]
  @readme_limit 40
  @canary %{
    ai: "This RFD was drafted by an AI and read by a human before it shipped.",
    human: "This RFD was drafted by a human without AI help."
  }
  @tropes [
    {~r/ [-—][-—]? /u, "an em-dash join"},
    {~r/\b(is|are)\s+what\s+(makes|proves|shows|says)\b/i, "a pompous copula"},
    {~r/\bthe exact (window|moment|shape|line|point|reason|failure)\b/i,
     "an `exact` on a soft noun"}
  ]

  @enforce_keys [:serial, :title]
  defstruct serial: nil,
            title: nil,
            state: :discussion,
            feature: nil,
            scope: nil,
            flight_level: nil,
            decision: nil,
            problem: nil,
            references: [],
            related: nil,
            details: [],
            drafted_by: :ai

  @type t :: %__MODULE__{}

  def states, do: @states
  def readme_limit, do: @readme_limit
  def canary(kind), do: Map.fetch!(@canary, kind)

  @doc "Every rule the README rendering has to meet, as a list of reasons it does not."
  def problems(%__MODULE__{} = d) do
    []
    |> check(
      is_integer(d.serial) and d.serial in 1000..9999,
      "serial must be a four-digit integer"
    )
    |> check(
      is_binary(d.title) and String.trim(d.title) != "",
      "title must be a non-empty string"
    )
    |> check(d.state in @states, "state #{inspect(d.state)} is not one of #{inspect(@states)}")
    |> check(
      d.decision != nil or d.state in @no_decision_states,
      "a Decision is required unless the state is one of #{inspect(@no_decision_states)}"
    )
    |> check(d.drafted_by in [:ai, :human], "drafted_by must be :ai or :human")
    |> check(d.flight_level in [nil, :l1, :l2, :l3], "flight_level must be :l1, :l2, :l3 or nil")
    |> check(
      Enum.all?(d.details, &match?({h, b} when is_binary(h) and is_binary(b), &1)),
      "each details entry is {heading, body}"
    )
    |> Kernel.++(trope_problems(d))
    |> Kernel.++(length_problems(d))
    |> Enum.reverse()
  end

  def validate!(%__MODULE__{} = d) do
    case problems(d) do
      [] ->
        d

      ps ->
        raise ArgumentError,
              "RFD #{d.serial} is outside RFD 1000's shape:\n  " <> Enum.join(ps, "\n  ")
    end
  end

  defp check(acc, true, _msg), do: acc
  defp check(acc, false, msg), do: [msg | acc]

  defp trope_problems(d) do
    prose = [d.decision, d.problem, d.related | Enum.map(d.details, &elem(&1, 1))]

    for text <- prose, is_binary(text), {re, name} <- @tropes, Regex.match?(re, text) do
      "prose carries #{name}: #{inspect(Regex.run(re, text) |> hd() |> String.trim())}"
    end
  end

  defp length_problems(d) do
    if d.decision == nil and d.state not in @no_decision_states do
      []
    else
      n = d |> readme() |> String.split("\n") |> length()

      if n > @readme_limit,
        do: ["README renders to #{n} lines; RFD 1000 allows #{@readme_limit}"],
        else: []
    end
  end

  @doc "The README as the gates and render_site.py read it."
  def readme(%__MODULE__{} = d) do
    meta =
      [
        "**State:** #{d.state}",
        d.feature && "**Feature:** #{d.feature}",
        d.scope && "**Scope:** #{d.scope}"
      ]
      |> Enum.reject(&is_nil/1)

    sections =
      [
        d.decision && section("Decision", d.decision <> details_pointer(d)),
        d.problem && section("Problem", d.problem),
        d.references != [] &&
          section("References", Enum.map_join(d.references, "\n", &("- " <> &1))),
        d.related && section("Related", d.related)
      ]
      |> Enum.reject(&(&1 in [nil, false]))

    (["# RFD #{d.serial}: #{d.title}", "", Enum.join(meta, "\n")] ++
       Enum.flat_map(sections, &["", &1]) ++ ["", canary(d.drafted_by)])
    |> Enum.join("\n")
    |> Kernel.<>("\n")
  end

  @doc "DETAILS.md, or nil when the RFD has no details."
  def details(%__MODULE__{details: []}), do: nil

  def details(%__MODULE__{} = d) do
    body = Enum.map_join(d.details, "\n\n", fn {h, b} -> section(h, b) end)
    "# RFD #{d.serial} details: #{d.title}\n\n#{canary(d.drafted_by)}\n\n#{body}\n"
  end

  @doc "A Quarto document with YAML front matter, the shape render_site.py's index.md has."
  def qmd(%__MODULE__{} = d) do
    front =
      [
        {"rfd", d.serial},
        {"title", d.title},
        {"state", Atom.to_string(d.state)},
        d.feature && {"feature", d.feature},
        d.scope && {"scope", d.scope},
        d.flight_level && {"flight_level", d.flight_level |> Atom.to_string() |> String.upcase()}
      ]
      |> Enum.reject(&(&1 in [nil, false]))
      |> Enum.map_join("\n", fn {k, v} -> "#{k}: #{yaml(v)}" end)

    body =
      d
      |> readme()
      |> String.split("\n")
      |> Enum.drop_while(
        &(&1 == "" or String.starts_with?(&1, "# ") or String.starts_with?(&1, "**"))
      )
      |> Enum.join("\n")

    "---\n#{front}\n---\n\n#{body}"
  end

  @doc "The register row fragment for SERIALS-*.usda, for a human to paste or a tool to insert."
  def register_row(%__MODULE__{} = d, slug) do
    level =
      if d.flight_level,
        do:
          "\n    custom string flight_level = \"#{d.flight_level |> Atom.to_string() |> String.upcase()}\"",
        else: ""

    "def \"S#{d.serial}\"\n{\n    custom string slug = \"#{slug}\"#{level}\n}\n"
  end

  defp section(heading, body), do: "## #{heading}\n\n#{String.trim_trailing(body)}"

  defp details_pointer(%{details: []}), do: ""
  defp details_pointer(_), do: "\n\n`DETAILS.md` carries the rest of this RFD."

  defp yaml(v) when is_integer(v), do: Integer.to_string(v)
  defp yaml(v) when is_binary(v), do: inspect(v)
end
