defmodule Servy.Handler do
  def handle(request) do
    request
    |> parse
    |> log
    |> route
    |> format_response
  end

  def log(conv), do: IO.inspect conv

  def parse(request) do
    [method, path, _] =
      request
      |> String.split("\n")
      |> List.first()
      |> String.split(" ")

    %{method: method, path: path, resp_body: ""}
  end

  def route(request) do
    route(request, request.method, request.path)
  end

  def route(request, "GET", "/wildthings") do
    # conv = Map.put(conv, :resp_body, "Bears)
    %{request | resp_body: "Bears, Lions, Tigers"}
  end

  def route(request, "GET", "/nicethings") do
    # conv = Map.put(conv, :resp_body, "Bears)
    %{request | resp_body: "Teddy Bears, Teddy Lions, Teddy Tigers"}
  end

  def format_response(request) do
    # TODO: Use values in the map to create an HTTP response string:
    """
    HTTP/1.1 200 OK
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

IO.puts(response)
