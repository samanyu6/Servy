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

    %{method: method, path: path, resp_body: "", status: nil}
  end

  def route(request) do
    route(request, request.method, request.path)
  end

  def route(request, "GET", "/wildthings") do
    # conv = Map.put(conv, :resp_body, "Bears)
    %{request | status: 200, resp_body: "Bears, Lions, Tigers"}
  end

  def route(request, "GET", "/bears") do
    # conv = Map.put(conv, :resp_body, "Bears)
    %{request | status: 200, resp_body: "Teddy, Smokey, Paddington"}
  end

  def route(request, "GET", "/bears" <> id) do
  end

  # error handling catch all route
  def route(request, _method, path) do
    %{request | status: 404, resp_body: "no #{path} found"}
  end

  def format_response(request) do
    # TODO: Use values in the map to create an HTTP response string:
    """
    HTTP/1.1 #{request.status} #{status_reason(request.status)}
    Content-Type: text/html
    Content-Length: #{String.length(request.resp_body)}

    #{request.resp_body}
    """
  end

  defp status_reason(code) do
    %{
      200 => "OK",
      201 => "Created",
      401 => "Unauthorized",
      403 => "Forbidden",
      404 => "Not Found",
      500 => "Internal Server Error"
    }[code]
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
