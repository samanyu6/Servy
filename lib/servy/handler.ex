defmodule Servy.Handler do
  @moduledoc "Servy files"
  import Servy.Plugins, only: [rewrite: 1, log: 1, trace: 1]
  import Servy.Parser, only: [parse: 1]
  import Servy.FileHandler, only: [get_page: 1, handle_file: 2]
  import Servy.BearController

  alias Servy.Video
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

  # route to bomb
  def route(%Conv{method: "GET", path: "/kaboom"} = _request) do
    raise "Kaboom"
  end

  def route(%Conv{ method: "GET", path: "/hibernate/" <> time} = request) do
    time |> String.to_integer |> :timer.sleep

    %{ request | status: 200, resp_body: "Awake"}
  end

  def route(%Conv{ method: "GET", path: "/snapshots"} = req) do
    snap1 = Video.get_snapshot("cam-1")
    snap2 = Video.get_snapshot("cam-2")
    snap3 = Video.get_snapshot("cam-3")

    snapshots = [snap1, snap2, snap3]

    %{ req | status: 200, resp_body: inspect snapshots}
  end

  def route(%Conv{method: "GET", path: "/wildthings"} = request) do
    # conv = Map.put(conv, :resp_body, "Bears)
    %{ request | status: 200, resp_body: "Bears, Lions, Tigers" }
  end

  def route(%Conv{method: "GET", path: "/bears"} = request) do
    BearController.index(request)
  end

  def route(%Conv{method: "GET", path: "/api/bears"} = request) do
    Servy.Api.BearController.index(request)
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

  def route(%Conv{method: "DELETE", path: "/bears/" <> id} = request) do
    params = Map.put(request.params, "id", id)
    BearController.delete(request, params)
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
    HTTP/1.1 #{Conv.full_status(request)}\r
    Content-Type: #{request.resp_content_type}\r
    Content-Length: #{byte_size(request.resp_body)}\r
    \r
    #{request.resp_body}
    """
  end

  def format_response(%Conv{} = request) do
    # TODO: Use values in the map to create an HTTP response string:
    """
    HTTP/1.1 #{Conv.full_status(request)}\r
    Content-Type: #{request.resp_content_type}\r
    Content-Length: #{String.length(request.resp_body)}\r
    \r
    #{request.resp_body}
    """
  end
end
