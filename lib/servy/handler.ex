defmodule Servy.Handler do
  @moduledoc "Servy files"
  import Servy.Plugins, only: [rewrite: 1, log: 1, trace: 1]
  import Servy.Parser, only: [parse: 1]
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

  def emojify(%{status: 200} = request) do
    %{request | resp_body: "🎉 #{request.resp_body} 🎉"}
  end

  def emojify(request), do: request




  def route(%{method: "GET", path: "/wildthings"} = request) do
    # conv = Map.put(conv, :resp_body, "Bears)
    %{ request | status: 200, resp_body: "Bears, Lions, Tigers" }
  end

  def route(%{method: "GET", path: "/bears"} = request) do
    # conv = Map.put(conv, :resp_body, "Bears)
    %{request | status: 200, resp_body: "Teddy, Smokey, Paddington"}
  end

  def route(%{method: "GET", path: "/bears/" <> id} = request) do
    %{request | status: 200, resp_body: "Bear #{id}"}
  end

  def route(%{method: "GET", path: "/pages/" <> name} = request) do
    get_page("#{name}.html")
     |> handle_file(request)
  end

  def route(%{method: "GET", path: "/bears/new"} = request) do
    get_page("form.html")
    |> handle_file(request)
  end

  def route(%{method: "DELETE", path: "/bears" <> _id} = request) do
    %{ request | status: 403, resp_body: "Deleting bears is forbidden"}
  end

  # error handling catch all route
  def route(request) do
    %{request | status: 404, resp_body: "no #{request.path} found"}
  end


  def get_page(page) do
    Path.expand("../../pages/", __DIR__)
    |> Path.join(page)
    |> File.read
  end


  def handle_file({:ok, content}, request) do
    %{request | status: 200, resp_body: content}
  end

  def handle_file({:ok, :enoent}, request) do
    %{request | status: 404, resp_body: "File not found"}
  end

  def handle_file({:error, reason}, request) do
    %{request | status: 500, resp_body: "Error reading file #{reason}"}
  end


  def format_response(%{resp_body: "🎉"} = request) do
    """
    HTTP/1.1 #{request.status} #{status_reason(request.status)}
    Content-Type: text/html
    Content-Length: #{byte_size(request.resp_body)}

    #{request.resp_body}
    """
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
