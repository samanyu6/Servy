defmodule Servy.Handler do
  @moduledoc "Servy files"
  import Servy.Plugins, only: [rewrite: 1, log: 1, trace: 1]
  import Servy.Parser, only: [parse: 1]
  import Servy.FileHandler, only: [get_page: 1, handle_file: 2]
  import Servy.BearController

  alias Servy.BearController
  alias Servy.Conv
 @doc "servy handler func"
  def handle(request) do
    request
    |> parse
    |> rewrite
    |> log
    |> route
    |> emojify
    |> trace
    |> format_response
  end

  def emojify(%Conv{status: 200} = request) do
    %{request | resp_body: "🎉 #{request.resp_body} 🎉"}
  end

  def emojify(%Conv{} = request), do: request

  def route(%Conv{method: "GET", path: "/wildthings"} = request) do
    # conv = Map.put(conv, :resp_body, "Bears)
    %{ request | status: 200, resp_body: "Bears, Lions, Tigers" }
  end

  def route(%Conv{method: "GET", path: "/bears"} = request) do
    BearController.index(request)
  end

  def route(%Conv{method: "GET", path: "/bears/new"} = request) do
    get_page("form.html")
    |> handle_file(request)
  end


  def route(%Conv{method: "GET", path: "/bears/" <> id} = request) do
    params = Map.put(request.params, "id", id)
    BearController.show(request, params)
  end

  def route(%Conv{method: "GET", path: "/pages/" <> name} = request) do
    get_page("#{name}.html")
     |> handle_file(request)
  end

  def route(%Conv{method: "DELETE", path: "/bears" <> _id} = request) do
    %{ request | status: 403, resp_body: "Deleting bears is forbidden"}
  end

  def route(%Conv{method: "POST", path: "/bears"} = request) do
    BearController.create(request, request.params)
  end

  # error handling catch all route
  def route(%Conv{} = request) do
    %{request | status: 404, resp_body: "no #{request.path} found"}
  end

  def format_response(%Conv{resp_body: "🎉"} = request) do
    """
    HTTP/1.1 #{Conv.full_status(request)}
    Content-Type: text/html
    Content-Length: #{byte_size(request.resp_body)}

    #{request.resp_body}
    """
  end

  def format_response(%Conv{} = request) do
    # TODO: Use values in the map to create an HTTP response string:
    """
    HTTP/1.1 #{Conv.full_status(request)}
    Content-Type: text/html
    Content-Length: #{String.length(request.resp_body)}

    #{request.resp_body}
    """
  end
end

request = """
GET /wildthings HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

response = Servy.Handler.handle(request)

IO.puts response

request = """
GET /bears HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

response = Servy.Handler.handle(request)

IO.puts response

request = """
GET /bigfoot HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

response = Servy.Handler.handle(request)

IO.puts response

request = """
GET /bears/1 HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

response = Servy.Handler.handle(request)

IO.puts response

request = """
GET /wildlife HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

response = Servy.Handler.handle(request)

IO.puts response

request = """
DELETE /bears/2 HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

response = Servy.Handler.handle(request)

IO.puts response

request = """
GET /bears?id=2 HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

response = Servy.Handler.handle(request)

IO.puts response

request = """
GET /tigers?id=2 HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

response = Servy.Handler.handle(request)

IO.puts response

request = """
GET /pages/about HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

response = Servy.Handler.handle(request)

IO.puts response

request = """
GET /pages/form HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

response = Servy.Handler.handle(request)

IO.puts response

request = """
GET /bears/new HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*

"""

response = Servy.Handler.handle(request)

IO.puts response

request = """
POST /bears HTTP/1.1
Host: example.com
User-Agent: ExampleBrowser/1.0
Accept: */*
Content-Type: application/x-www-form-urlencoded
Content-Length: 21

name=Baloo&type=Brown
"""

response = Servy.Handler.handle(request)

IO.puts response
