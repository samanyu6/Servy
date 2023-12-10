defmodule Servy.Parser do

  alias Servy.Conv
  def parse(request) do
    [top, params_string] = String.split(request, "\n\n")

    [request_line | header_lines] = String.split(top, "\n")

    [method, path, _] = String.split(request_line, " ")

    headers = parse_headers(header_lines)
    params = parse_params(headers["Content-Type"], params_string)

    %Conv{method: method, path: path, params: params, headers: headers }
  end

  def parse_params("application/x-www-form-urlencoded", params_string) do
    params_string |> String.trim |> URI.decode_query
  end

  def parse_params(_, _), do: %{}

  # recursively pick out head and body
  def parse_headers(header_lines) do
    Enum.reduce(header_lines, %{}, fn(line, header_map) ->
        [k, v] = String.split(line, ": ")
        Map.put(header_map, k, v)
    end)
  end

end
