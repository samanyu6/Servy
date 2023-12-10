require Logger

defmodule Servy.Plugins do

  alias Servy.Conv

  def log(conv) do
    Logger.info conv
    conv
  end


  def rewrite(%Conv{path: "/wildlife"} = request) do
    %{request | path: "/wildthings"}
  end

  def rewrite(%Conv{path: path} = request) do
    regex = ~r{\/(?<thing>\w+)\?id=(?<id>\d+)}
    captures = Regex.named_captures(regex, path)
    rewrite_path_captures(request, captures)
  end

  def rewrite(%Conv{} = request), do: request

  def rewrite_path_captures(%Conv{} = request, %{"thing" => thing, "id"=> id}) do
    %{ request | path: "/#{thing}/#{id}"}
  end

  def rewrite_path_captures(%Conv{} = request, nil), do: request

  def trace(%Conv{status: 404, path: path} = request) do
    Logger.warning "Warning: Path #{path} is unmatched"
    request
  end

  def trace(%Conv{} = request) do
    if Mix.env == :dev do
      IO.inspect request
    end
  end
end
