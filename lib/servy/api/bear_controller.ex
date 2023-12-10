defmodule Servy.Api.BearController do
  def index(request) do
    json = Servy.Wildthings.list_bears()
      |> Poison.encode!

      %{ request | status: 200, resp_body: json}
  end
end
