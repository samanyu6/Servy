defmodule Servy.FileHandler do

  @page_path  Path.expand("pages", File.cwd!)

  def get_page(page) do
    @page_path
    |> Path.join(page)
    |> File.read
  end

  def handle_file({:ok, :enoent}, request) do
    %{request | status: 404, resp_body: "File not found"}
  end

  def handle_file({:ok, content}, request) do
    %{request | status: 200, resp_body: content}
  end

  def handle_file({:error, reason}, request) do
    %{request | status: 500, resp_body: "Error reading file #{reason}"}
  end
end
