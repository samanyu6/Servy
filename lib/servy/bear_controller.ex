defmodule Servy.BearController do
  def index(request) do
    %{request | status: 200, resp_body: "Teddy, Smokey, Paddington"}
  end

  def show(request, %{"id" => id}) do
    %{request | status: 200, resp_body: "Bear #{id}"}
  end

  def create(request, %{"name" => name, "type" => type}) do
    %{request | status: 201, resp_body: "Created a #{type} bear named #{name}"}
  end
end
