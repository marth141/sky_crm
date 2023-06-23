# HubspotApi

This application is used to be a wrapper over the Hubspot API as detailed by their endpoint.

`HubspotApi` uses `:tesla` as a network adapter for making `:GET, :POST, :PATCH, :DELETE, :PUT` requests.

There are `collectors` in this application which just try to mirror Hubspot.

`:messaging` can be used to broadcast events about HubspotApi to other things.

`:time_api` provides most date/datetime convienences

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `hubspot_api` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:hubspot_api, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/hubspot_api](https://hexdocs.pm/hubspot_api).

