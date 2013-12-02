defmodule Mix.Tasks.Compile.ModuleTranspiler do
  use Mix.Task

  alias Syphon.ModuleTranspiler

  def run(args) do
    { opts, inputs, _ } = OptionParser.parse(args)

    output = opts[:output] || "app.js"
    if inputs == [], do: inputs = ["app"]

    context = ModuleTranspiler.init

    modules = lc dir inlist inputs do
      lc path inlist Path.wildcard("#{dir}/**/*.js") do
        name = Path.rootname(Path.relative_to(path, dir))
        contents = File.read!(path)
        compiled = ModuleTranspiler.compile(context, contents, name)
        "#{compiled}\n"
      end
    end

    File.write! output, Enum.join(modules, "\n")
  end
end
