defmodule Servy.BearController do
  alias Servy.Wildthings
  def index(request) do
    bears = Wildthings.list_bears()
    |> Enum.filter(fn (bear) -> bear.type == "Grizzly"  end)
    |> Enum.sort(fn (a, b) -> a.name <= b.name  end)
    |> Enum.map(fn(bear) -> "<li>#{bear.name} - #{bear.type}</li>"  end)
    |> Enum.join
    %{request | status: 200, resp_body: "<ul>#{bears}</ul>"}
  end

  def show(request, %{"id" => id}) do
    bear = Wildthings.get_bear(id)
    %{request | status: 200, resp_body: "<h1>Bear #{bear.id}: #{bear.name}</h1>"}
  end

  @spec create(%{:resp_body => any(), :status => any(), optional(any()) => any()}, map()) :: %{
          :resp_body => <<_::64, _::_*8>>,
          :status => 201,
          optional(any()) => any()
        }
  def create(request, %{"name" => name, "type" => type}) do
    %{request | status: 201, resp_body: "Created a #{type} bear named #{name}"}
  end
end
