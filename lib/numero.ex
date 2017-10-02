defmodule Numero do
  @moduledoc """
  Numero cat either normalize non-english digits in strings,
  or convert english digits to non-english digits of your choice.
  """

  @arabic_zero 1632
  @persian_zero 1776
  @nko_zero 1984
  @numbers ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9']

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
    |> replace_chars([])
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

    number_type =
      cond do
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

  @doc """
  Checks if all characters in a given string is numerical

  ## Examples
      iex> Numero.is_digit_only?("1234567890")
      true

      iex> Numero.is_digit_only?("12 34")
      false

      iex> Numero.is_digit_only?("a123")
      false
  """
  @spec is_digit_only?(String.t) :: boolean()
  def is_digit_only?(str) do
    is_digit?(str)
  end


  @doc """
  Removes non digit chars from a given string

  ## Parameters
    - str: A given string to remove non numerical chars from
    - exceptions(optional): a list of chars to accept and dont remove. e.g.: [' ', 'a']

  ## Examples
      iex> Numero.remove_non_digits("0 1 2 3 4 5 6 7 8 9 abcd")
      "0123456789"

      iex> Numero.remove_non_digits("0 1 2 3 4 5 6 7 8 9 abcd", ['a', ' '])
      "0 1 2 3 4 5 6 7 8 9 a"

      iex> Numero.remove_non_digits("")
      ""

      iex> Numero.remove_non_digits("a0b1c2.,asd(*$!@#!@9-=+)")
      "0129"
  """
  @spec remove_non_digits(String.t, List.t) :: String.t
  def remove_non_digits(str, exceptions \\ []) do
    str
    |> String.to_charlist
    |> do_remove_non_digits(exceptions, [])
    |> to_string
  end

  ###########
  # Helpers #
  ###########

  defp do_remove_non_digits([], _exceptions, acc), do: acc

  defp do_remove_non_digits([char | tail], exceptions, acc) do
    if does_match_any?(char, @numbers ++ exceptions) do
      do_remove_non_digits(tail, exceptions, acc ++ [char])
    else
      do_remove_non_digits(tail, exceptions, acc)
    end
  end

  defp replace_chars([], acc), do: to_string(acc)

  defp replace_chars([char | tail], acc, output_non_digit \\ true) do
    num =
      cond do
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
        true and output_non_digit ->
          char
        true ->
          ""
      end

    replace_chars(tail, acc ++ [num])
  end

  defp is_digit?(str) do
    if String.trim(str) == "" do
      false
    else
      norm_str = normalize(str) |> String.to_charlist

      case norm_str do
        [] -> false
        _ -> do_is_digit?(norm_str)
      end
    end
  end

  defp do_is_digit?([]), do: true

  defp do_is_digit?([char | tail]) do
    if does_match_any?(char, @numbers) do
      do_is_digit?(tail)
    else
      false
    end
  end

  defp does_match_any?(_char, []), do:
    false

  defp does_match_any?(char, [pattern | tail]) do
    if [char] == pattern do
      true
    else
      does_match_any?(char, tail)
    end
  end
end
