defmodule Servy.View do
  @templates_path Path.expand("../templates", __DIR__)

  def render(request, template, bindings \\ []) do
    content = @templates_path
    |> Path.join(template)
    |> EEx.eval_file(bindings)

    %{request | status: 200, resp_body: content}
  end
end
