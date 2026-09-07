defmodule Mix.Tasks.Rfd.Render do
  @shortdoc "Render README.md (and DETAILS.md) from each rfd/NNNN-slug/rfd.exs"
  @moduledoc """
      mix rfd.render [--check] [--qmd] [PATH ...]

  PATH is an `rfd.exs` file or an RFD directory; with none, every `rfd.exs`
  under `../rfd` is rendered. `--check` writes nothing and fails when what is on
  disk differs from what the source renders to. `--qmd` also writes `index.qmd`
  with YAML front matter, for a Quarto project without `render_site.py`.
  """
  use Mix.Task

  @impl true
  def run(args) do
    {opts, paths, _} = OptionParser.parse(args, strict: [check: :boolean, qmd: :boolean])
    sources = if paths == [], do: RFD.Source.all(), else: Enum.map(paths, &RFD.Source.at/1)
    if sources == [], do: Mix.raise("no rfd.exs found")

    results = Enum.map(sources, &RFD.Source.render(&1, opts))
    bad = Enum.filter(results, &match?({:drift, _, _}, &1))

    for r <- results do
      case r do
        {:ok, dir, files} ->
          Mix.shell().info("ok    #{dir}: #{Enum.join(files, ", ")}")

        {:same, dir} ->
          Mix.shell().info("same  #{dir}")

        {:drift, dir, files} ->
          Mix.shell().error("DRIFT #{dir}: #{Enum.join(files, ", ")} differ from rfd.exs")
      end
    end

    if bad != [],
      do: Mix.raise("#{length(bad)} RFD(s) drifted from their source; run `mix rfd.render`")
  end
end

defmodule Mix.Tasks.Rfd.Check do
  @shortdoc "Fail when any README.md/DETAILS.md differs from its rfd.exs (alias of rfd.render --check)"
  @moduledoc false
  use Mix.Task

  @impl true
  def run(args), do: Mix.Tasks.Rfd.Render.run(["--check" | args])
end

defmodule RFD.Source do
  @moduledoc "Locate, compile and render `rfd.exs` sources."

  def rfd_root, do: Path.expand("../rfd", File.cwd!())

  def all do
    rfd_root() |> Path.join("*/rfd.exs") |> Path.wildcard() |> Enum.sort()
  end

  def at(path) do
    cond do
      File.regular?(path) -> Path.expand(path)
      File.dir?(path) -> Path.expand(Path.join(path, "rfd.exs"))
      true -> Path.expand(Path.join([rfd_root(), path, "rfd.exs"]))
    end
  end

  @doc "Compile one source and return its RFD.Doc; the compile itself validates it."
  def load(path) do
    mods = Code.compile_file(path) |> Enum.map(&elem(&1, 0))

    case Enum.filter(mods, &function_exported?(&1, :__rfd__, 0)) do
      [mod] -> mod.__rfd__()
      [] -> raise ArgumentError, "#{path} defines no module that uses RFD.DSL"
      many -> raise ArgumentError, "#{path} defines #{length(many)} RFD modules; one per file"
    end
  end

  def render(path, opts) do
    dir = Path.dirname(path)
    doc = load(path)
    slug_serial = dir |> Path.basename() |> String.slice(0, 4)

    if Integer.to_string(doc.serial) != slug_serial do
      raise ArgumentError,
            "#{path}: serial #{doc.serial} does not match the directory #{Path.basename(dir)}"
    end

    wanted =
      [{"README.md", RFD.Doc.readme(doc)}, {"DETAILS.md", RFD.Doc.details(doc)}] ++
        if(opts[:qmd], do: [{"index.qmd", RFD.Doc.qmd(doc)}], else: [])

    wanted = Enum.reject(wanted, fn {_, body} -> is_nil(body) end)

    differing =
      for {name, body} <- wanted, File.read(Path.join(dir, name)) != {:ok, body}, do: name

    cond do
      differing == [] ->
        {:same, Path.basename(dir)}

      opts[:check] ->
        {:drift, Path.basename(dir), differing}

      true ->
        for {name, body} <- wanted, name in differing, do: File.write!(Path.join(dir, name), body)
        {:ok, Path.basename(dir), differing}
    end
  end
end
