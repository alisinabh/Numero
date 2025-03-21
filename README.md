# Numero

[![Build Status][build-badge]][repo] [![Module Version][version-shield]][hex]
[![Hex Docs][docs-badge]][hexdocs]

Numero is a micro library for converting non-Western Arabic numerals, such as ۱
(Farsi), ۲ (Bengali), ۳ (Devanagari), ੪ (Gurmukhi), and ๕ (Thai), into Western
Arabic numerals (1, 2, 3, 4, and 5, respectively). It also provides conversion
into `integer()` and `float()` [basic types][bt].

## Supported Languages / Scripts

All numbers defined in Unicode 16.0.0 as `Nd` (numeric digit) class are
supported. For more information, see the Unicode specification chapter 4,
[Character Properties][core-spec-4] sections on General Category and Numeric
Value.

The conversion routine is derived from [DerivedNumericValues.txt][dnv].

## Installation

Numero can be installed by adding `numero` to your list of dependencies in
`mix.exs`:

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

[dnv]: https://www.unicode.org/Public/16.0.0/ucd/extracted/DerivedNumericValues.txt
[core-spec-4]: https://www.unicode.org/versions/Unicode16.0.0/core-spec/chapter-4/
[bt]: https://hexdocs.pm/elixir/typespecs.html#basic-types
[build-badge]: https://github.com/alisinabh/Numero/actions/workflows/ci.yml/badge.svg
[repo]: https://github.com/alisinabh/Numero
[version-shield]: https://img.shields.io/hexpm/v/numero.svg
[hex]: https://hex.pm/packages/numero
[docs-badge]: https://img.shields.io/badge/hex-docs-lightgreen.svg
[hexdocs]: https://hexdocs.pm/numero/
