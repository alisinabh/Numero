defmodule Numero do
  @moduledoc """
  Numero cat either normalize non-english digits in strings,
  or convert english digits to non-english digits of your choice.
  """

  @arabic_zero 1632
  @persian_zero 1776
  @nko_zero 1984

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
  def normalize(number_str) do
    number_str
    |> String.to_charlist
    |> replace_chars("")
  end

  defp replace_chars([], acc), do: acc

  defp replace_chars([char | tail], acc) do
    num = cond do
      char >= @arabic_zero and char <= (@arabic_zero + 9) ->
        # Arabic normal numbers
        char - @arabic_zero + 48
      char == 1759 or char == 1760 ->
        # Arabic custom zero
        48
      char >= @persian_zero and char <= (@persian_zero + 9) ->
        # Persian numbers
        char - @persian_zero + 48
      char >= @nko_zero and char <= (@nko_zero + 9) ->
        # NKO numbers
        char - @nko_zero + 48
      true ->
        char
    end

    replace_chars(tail, acc <> <<num>>)
  end

  @doc """
  Converts a string number to number (Integer or Float)

  Returns ``:error`` if input string is not in correct format.

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
      _ -> :error
    end
  end

  @doc """
  Converts a string number to number (Integer or Float)

  Throws match error if input string is not in correct format

  ## Examples
      iex> Numero.normalize_as_number!("1۲3")
      123

      iex> Numero.normalize_as_number!("1۲3.1۱۰")
      123.11
  """
  @spec normalize_as_number!(String.t) :: Integer.t | Float.t
  def normalize_as_number!(number_str) do
    {:ok, number} = normalize_as_number(number_str)
    number
  end
end
