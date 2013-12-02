defmodule Mix.Tasks.Compile.HandlebarsTest do
  use ExUnit.Case

  @compiled_path Path.expand("../../tmp/templates.js", __DIR__)
  @templates_dir Path.expand("../../support/templates", __DIR__)

  setup_all do
    File.mkdir_p! Path.dirname(@compiled_path)
    :ok
  end

  teardown_all do
    File.rm_rf! Path.dirname(@compiled_path)
    :ok
  end

  test "precompiles templates to output file" do
    args = ["--output", @compiled_path, @templates_dir]
    Mix.Tasks.Compile.Handlebars.run(args)

    source = """
    var Ember = {};
    Ember.TEMPLATES = {};
    #{File.read!(@compiled_path)};
    function test(templateName) {
      return templateName in Ember.TEMPLATES;
    }
    """

    context = Execjs.compile(source)
    assert Execjs.call(context, "test", ["application"])
    assert Execjs.call(context, "test", ["contacts/index"])
  end
end
