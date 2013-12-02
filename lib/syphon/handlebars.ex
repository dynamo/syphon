defmodule Syphon.Handlebars do
  def init do
    Execjs.compile(source)
  end

  def precompile(context, input) do
    Execjs.call(context, "Handlebars.precompile", [input])
  end

  app = Mix.project[:app]
  priv_dir = :code.priv_dir(app)

  handlebars_path = Path.join([ priv_dir, "handlebars.js" ])
  handlebars_source = File.read!(handlebars_path)

  defp source do
    unquote(handlebars_source)
  end
end
