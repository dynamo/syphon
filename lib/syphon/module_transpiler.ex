defmodule Syphon.ModuleTranspiler do
  def init do
    Execjs.compile(source)
  end

  def compile(context, input, module) do
    Execjs.call(context, "compileTemplate", [input, module])
  end

  app = Mix.project[:app]
  priv_dir = :code.priv_dir(app)

  transpiler_path = Path.join([ priv_dir, "es6-module-transpiler.js" ])

  prelude = """
  var module = {}, exports;
  exports = module.exports = {};
  """

  postlude = """
  var Compiler = module.exports.Compiler;
  function compileTemplate(inputString, moduleName) {
    var compiler = new Compiler(inputString, moduleName);
    return compiler.toAMD();
  }
  """

  transpiler_source = prelude <> File.read!(transpiler_path) <> postlude

  defp source do
    unquote(transpiler_source)
  end
end
