defmodule Numero do
  @moduledoc """
  Numero cat either normalize non-english digits in strings,
  or convert english digits to non-english digits of your choice.
  """

  alias Numero.Numbers, as: N

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
  @spec normalize(String.t()) :: String.t()
  def normalize(number_str) do
    number_str
    |> N.replace_chars("")
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
  @spec normalize_as_number(String.t()) :: {:ok, number()} | :error
  def normalize_as_number(number_str) do
    num =
      number_str
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
  @spec normalize_as_number!(String.t()) :: number()
  def normalize_as_number!(number_str) do
    {:ok, number} = normalize_as_number(number_str)
    number
  end

  @doc false
  def is_digit_only?(str), do: N.digit_only?(str)

  @doc """
  Checks if all characters in a given string is numerical (In any utf number bases)

  ## Examples
      iex> Numero.digit_only?("1234567890")
      true

      iex> Numero.digit_only?("12 34")
      false

      iex> Numero.digit_only?("a123")
      false

      iex> Numero.digit_only?("۱۲۳") # Persian digits
      true
  """
  @spec digit_only?(String.t()) :: boolean()
  def digit_only?(str), do: N.digit_only?(str)

  @doc """
  Removes non digit chars from a given string

  ## Parameters
    - str: A given string to remove non numerical chars from
    - exceptions(optional): a list of chars to accept and dont remove. e.g.: ~c[a ]

  ## Examples
      iex> Numero.remove_non_digits("0 1 2 3 4 5 6 7 8 9 abcd")
      "0123456789"

      iex> Numero.remove_non_digits("0 1 2 3 4 5 6 7 8 9 abcd", ~c[a ])
      "0 1 2 3 4 5 6 7 8 9 a"

      iex> Numero.remove_non_digits("")
      ""

      iex> Numero.remove_non_digits("a0b1c2.,asd(*$!@#!@9-=+)")
      "0129"
  """
  @spec remove_non_digits(String.t(), list()) :: String.t()
  def remove_non_digits(str, exceptions \\ []) do
    str
    |> N.remove_outer(exceptions, "")
    |> to_string
  end
end
