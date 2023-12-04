defmodule Servy.BearController do
  alias Servy.Wildthings
  alias Servy.Bear

  defp bear_item(bear) do
    "<li>#{bear.name} - #{bear.type}</li>"
  end

  def index(request) do
    # all do the same thing
    bears = Wildthings.list_bears()
    |> Enum.filter(&Bear.is_grizzly/1)
    |> Enum.sort(&Bear.order_asc_by_name(&1, &2))
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

  def delete(request, %{"id" => id}) do
    bear = Wildthings.get_bear(id)
    %{ request | status: 403, resp_body: "Deleting bear: #{bear.name}"}
  end
end
