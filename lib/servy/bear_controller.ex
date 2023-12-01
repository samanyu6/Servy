defmodule Servy.BearController do
  def index(request) do
    %{request | status: 200, resp_body: "Teddy, Smokey, Paddington"}
  end

  def show(request, %{"id" => id}) do
    %{request | status: 200, resp_body: "Bear #{id}"}
  end
end
