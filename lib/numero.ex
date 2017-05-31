defmodule Numero do
  @moduledoc """
  Numero converts non standard number characters to standard english characters
  """

  @doc """
  Converts a string number to its standard english format

  ## Examples
  iex> Numero.normalize("1۲3")
  "123"

  iex> Numero.normalize("1۲3.1۱۰")
  "123.110"

  iex> Numero.normalize("1۲a3.1۱۰ hello")
  "12a3.110 hello"
  """
  @spec normalize(String.t) :: String.t
  def normalize(number) do
    number
    |> String.to_charlist
    |> replace_chars("")
  end

  defp replace_chars([], acc), do: acc

  defp replace_chars([char | tail], acc) do
    require Logger
    num = cond do
      char >= 1632 and char <= 1641 ->
        # Arabic normal numbers
        char - 1584
      char == 1759 or char == 1760 ->
        # Arabic custom zero
        48
      char >= 1776 and char <= 1785 ->
        # Persian numbers
        char - 1728
      char >= 1984 and char <= 1993 ->
        # NKO numbers
        char - 1936
      true ->
        char
    end

    replace_chars(tail, acc <> <<num>>)
  end

  @doc """
  Converts a string number to number (Integer or Float)

  ## Examples
  iex> Numero.normalize_as_number("1۲3")
  {:ok, 123}

  iex> Numero.normalize_as_number("1۲3.1۱۰")
  {:ok, 123.11}

  iex> Numero.normalize_as_number("1a3.1")
  :error
  """
  @spec normalize_as_number(String.t) :: {:ok, Integer.t} | {:ok, Float.t} | :error
  def normalize_as_number(number_str) do
    num = number_str
          |> normalize

    number_type = cond do
      String.contains?(num, ".") -> Float
      true -> Integer
    end

    num = number_type.parse(num)

    case num do
      {number, ""} -> {:ok, number}
      {_, str} -> :error
      :error -> :error
    end
  end
end
