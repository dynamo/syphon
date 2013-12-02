defmodule Mix.Tasks.Compile.ModuleTranspilerTest do
  use ExUnit.Case

  @almond_path Path.expand("../../support/vendor/almond.js", __DIR__)

  @app_dir Path.expand("../../support/app", __DIR__)
  @compiled_path Path.expand("../../tmp/app.js", __DIR__)

  setup_all do
    File.mkdir_p! Path.dirname(@compiled_path)
    :ok
  end

  teardown_all do
    File.rm_rf! Path.dirname(@compiled_path)
    :ok
  end

  test "compiles ES6 modules to AMD modules" do
    args = ["--output", @compiled_path, @app_dir]
    Mix.Tasks.Compile.ModuleTranspiler.run(args)

    source = """
    #{File.read!(@almond_path)};
    #{File.read!(@compiled_path)};
    function test(moduleName) {
      return require(moduleName) !== undefined;
    }
    """

    context = Execjs.compile(source)
    assert Execjs.call(context, "test", ["app"])
    assert Execjs.call(context, "test", ["resolver"])
  end
end
