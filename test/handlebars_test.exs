defmodule HandlebarsTest do
  use ExUnit.Case

  alias Syphon.Handlebars

  test :precompile do
    context = Handlebars.init
    assert Handlebars.precompile(context, "{{name}}") =~ %r/function/
  end
end
