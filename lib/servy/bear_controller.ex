defmodule Servy.BearController do
  alias Servy.Wildthings
  alias Servy.Bear

  defp bear_item(bear) do
    "<li>#{bear.name} - #{bear.type}</li>"
  end

  def index(request) do
    bears = Wildthings.list_bears()
    |> Enum.filter(fn (bear) -> Bear.is_grizzly(bear)  end)
    |> Enum.sort(fn (a, b) -> a.name <= b.name  end)
    |> Enum.map(fn(bear) ->  bear_item(bear) end)
    |> Enum.join
    %{request | status: 200, resp_body: "<ul>#{bears}</ul>"}
  end

  def show(request, %{"id" => id}) do
    bear = Wildthings.get_bear(id)
    %{request | status: 200, resp_body: "<h1>Bear #{bear.id}: #{bear.name}</h1>"}
  end

  def create(request, %{"name" => name, "type" => type}) do
    %{request | status: 201, resp_body: "Created a #{type} bear named #{name}"}
  end
end
