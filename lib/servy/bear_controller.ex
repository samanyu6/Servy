defmodule Servy.BearController do
  alias Servy.Wildthings
  def index(request) do
    bears = Wildthings.list_bears()
    %{request | status: 200, resp_body: "<ul><li></li></ul>"}
  end

  def show(request, %{"id" => id}) do
    %{request | status: 200, resp_body: "Bear #{id}"}
  end

  def create(request, %{"name" => name, "type" => type}) do
    %{request | status: 201, resp_body: "Created a #{type} bear named #{name}"}
  end
end
