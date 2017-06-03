# Numero

A micro library for converting non-english digits.

## Installation

Numero can be installed
by adding `numero` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [{:numero, "~> 0.1.0"}]
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

[https://hexdocs.pm/numero](https://hexdocs.pm/numero).
