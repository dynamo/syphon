defmodule ModuleTranspilerTest do
  use ExUnit.Case

  alias Syphon.ModuleTranspiler

  test :compile do
    context = ModuleTranspiler.init
    assert ModuleTranspiler.compile(context, "export var foo = \"foo\";", "foo") =~ %r/define/
  end
end
