defmodule Mix.Tasks.UpdateUnicode do
  @moduledoc "Downloads the latest Unicode extracted numeric data"
  @shortdoc "Update libphonenumber metadata"

  use Mix.Task

  require Logger

  @unicode_version "16.0.0"

  @version_url "https://www.unicode.org/versions/latest/"
  @values_url "https://www.unicode.org/Public/:version/ucd/extracted/DerivedNumericValues.txt"

  @generated_file "lib/numero/numbers.ex"
  @resource_file "support/DerivedNumericValues.txt"
  @task_file __ENV__.file
  @template_file "support/templates/numbers.ex.eex"

  @external_resource @template_file

  @impl Mix.Task
  def run(_args) do
    Application.ensure_all_started(:req)

    resource = Path.join(File.cwd!(), @resource_file)
    latest_version = fetch_latest_unicode_version!()

    if File.exists?(resource) && Version.compare(latest_version, @unicode_version) != :gt do
      Logger.info(
        "Regenerating code from Unicode DerivedNumericValues.txt (v#{@unicode_version})"
      )

      zeros =
        resource
        |> File.read!()
        |> parse()

      regenerate_code(@unicode_version, zeros)
    else
      Logger.info("Downloading latest Unicode DerivedNumericValues.txt (v#{latest_version})")

      zeros = download!(latest_version, resource)

      update_task(latest_version)
      update_readme(latest_version)
      regenerate_code(latest_version, zeros)
    end
  end

  defp download!(version, path) do
    %{status: 200, body: body} =
      Req.get!(req(), url: @values_url, path_params: [version: version])

    contents =
      body
      |> remove_bom()
      |> dos2unix()

    mkpaths!(path)

    File.write!(path, contents)

    parse(contents)
  end

  defp parse(contents) do
    contents
    |> String.split("\n")
    |> Enum.filter(&(String.contains?(&1, "# Nd ") && String.contains?(&1, "ZERO")))
    |> Enum.map(fn line ->
      [code_str] =
        ~r/\A([[:xdigit:]]+)/
        |> Regex.scan(line, capture: :all_but_first)
        |> List.flatten()

      String.to_integer(code_str, 16)
    end)
  end

  defp update_task(latest_version) do
    updated_task =
      @task_file
      |> File.read!()
      |> String.replace(
        ~r{@unicode_version "\d+\.\d+\.\d+"},
        ~s[@unicode_version "#{latest_version}"]
      )

    File.write!(@task_file, updated_task)
  end

  defp update_readme(latest_version) do
    current_version =
      @unicode_version
      |> Regex.escape()
      |> Regex.compile!()

    readme_path = Path.join(File.cwd!(), "README.md")

    updated_content =
      readme_path
      |> File.read!()
      |> String.replace(current_version, latest_version)

    File.write!(readme_path, updated_content)
  end

  defp regenerate_code(latest_version, zeros) do
    path = Path.join(File.cwd!(), @generated_file)

    mkpaths!(path)

    contents =
      @template_file
      |> EEx.eval_file(assigns: [version: latest_version, zeros: zeros], trim: true)
      |> Code.format_string!()

    File.write!(path, [contents | "\n"])
  end

  defp req(), do: Req.new(headers: [user_agent: "numero"])

  defp fetch_latest_unicode_version! do
    req()
    |> Req.get!(url: @version_url, redirect: false)
    |> Map.fetch!(:headers)
    |> Map.fetch!("location")
    |> hd()
    |> String.split("/", trim: true)
    |> Enum.reverse()
    |> hd()
    |> String.replace_prefix("Unicode", "")
  end

  def dos2unix(contents), do: String.replace(contents, "\r\n", "\n")

  def remove_bom(<<0xEF, 0xBB, 0xBF, rest::binary>>), do: rest
  def remove_bom(binary), do: binary

  defp mkpaths!(path) do
    path
    |> Path.dirname()
    |> File.mkdir_p!()
  end
end
