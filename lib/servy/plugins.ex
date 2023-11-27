require Logger

defmodule Servy.Plugins do

  def log(conv) do
    Logger.info conv
    conv
  end


  def rewrite(%{path: "/wildlife"} = request) do
    %{request | path: "/wildthings"}
  end

  def rewrite(%{path: path} = request) do
    regex = ~r{\/(?<thing>\w+)\?id=(?<id>\d+)}
    captures = Regex.named_captures(regex, path)
    rewrite_path_captures(request, captures)
  end

  def rewrite(request), do: request

  def rewrite_path_captures(request, %{"thing" => thing, "id"=> id}) do
    %{ request | path: "/#{thing}/#{id}"}
  end

  def rewrite_path_captures(request, nil), do: request

  def trace(%{status: 404, path: path} = request) do
    Logger.warning "Warning: Path #{path} is unmatched"
    request
  end

  def trace(request), do: request
end
