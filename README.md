# Numero

[![Build Status](https://travis-ci.org/alisinabh/Numero.svg?branch=master)](https://travis-ci.org/alisinabh/Numero)
[![Hex.pm](https://img.shields.io/badge/hex-0.3.0-blue.svg)](https://hex.pm/packages/numero)
![Hex.pm](https://img.shields.io/hexpm/dt/numero.svg)


A micro library for converting non-english UTF8 digits. (like ۱=1, ۲=2)

## Supported languages

Almost all numbers defined in Unicode is supported in Numero.

For more info on supported characters you can visit [here](http://www.fileformat.info/info/unicode/category/Nd/list.htm)

## Installation

Numero can be installed
by adding `numero` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [{:numero, "~> 0.3.0"}]
end
```

## Using Numero

On strings for strings:

```elixir
result = Numero.normalize("1۲۳۰4a۳tس")
# result = "12304a3tس"
```

Smart numeric convert:

(Convert numbers to Integer or Float based on input string)

```elixir
result = Numero.normalize_as_number("1۲۳۰4۳")
# result = {:ok, 123043}

result = Numero.normalize_as_number("1۲۳۰4۳.۴5")
# result = {:ok, 123043.45}

result = Numero.normalize_as_number!("1۲۳۰4۳.۴5")
# result = 123043.45
```

Strip all non numeric chars from a string:

```elixir
result = Numero.remove_non_digits("12 345abs")
# result = "12345"

# Or even make exceptions for some chars like 'a' and ' ' (space)
result = Numero.remove_non_digits("12 345bas", ~c[a ])
# result = "12 345a"
```

Checking if a string is all numbers
```elixir
result = Numero.digit_only?("1234567890")
# result = true

result = Numero.digit_only?("1234567890.a")
# result = false
```

[https://hexdocs.pm/numero](https://hexdocs.pm/numero).
