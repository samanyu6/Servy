defmodule Servy.BearController do
  alias Servy.Wildthings
  alias Servy.Bear

  @templates_path Path.expand("../templates", __DIR__)

  # default args \\
  defp render(request, template, bindings \\ []) do
    content = @templates_path
    |> Path.join(template)
    |> EEx.eval_file(bindings)

    %{request | status: 200, resp_body: content}
  end

  def index(request) do
    # all do the same thing
    bears = Wildthings.list_bears()
    |> Enum.sort(&Bear.order_asc_by_name(&1, &2))

    render(request, "index.eex", bears: bears)
  end

  def show(request, %{"id" => id}) do
    bear = Wildthings.get_bear(id)

    render(request, "show.eex", bear: bear)
  end

  def create(request, %{"name" => name, "type" => type}) do
    %{request | status: 201, resp_body: "Created a #{type} bear named #{name}"}
  end

  def delete(request, %{"id" => id}) do
    bear = Wildthings.get_bear(id)
    %{ request | status: 403, resp_body: "Deleting bear: #{bear.name}"}
  end
end
