defmodule Mix.Tasks.Compile.Handlebars do
  use Mix.Task

  alias Syphon.Handlebars

  def run(args) do
    { opts, inputs, _ } = OptionParser.parse(args)

    output = opts[:output] || "templates.js"
    if inputs == [], do: inputs = ["templates"]

    context = Handlebars.init

    templates = lc dir inlist inputs do
      lc path inlist Path.wildcard("#{dir}/**/*.handlebars") do
        name = Path.rootname(Path.relative_to(path, dir))
        contents = File.read!(path)
        compiled = Handlebars.precompile(context, contents)
        "Ember.TEMPLATES['#{name}'] = #{compiled};\n"
      end
    end

    File.write! output, Enum.join(templates, "\n")
  end
end
