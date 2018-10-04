[
  inputs: [
    "mix.exs",
    "{config,lib,test,priv}/**/*.{ex,exs}",
    "apps/*/mix.exs",
    "apps/*/{config,lib,test,priv}/**/*.{ex,exs}"
  ],
  line_length: 80,
  locals_without_parens: [
    # elixir
    defstruct: :*,
    defmodule: :*,
    send: :*,
    spawn: :*,

    # ecto
    create: :*,
    drop: :*,
    remove: :*,
    modify: :*,
    field: :*,
    belongs_to: :*,
    schema: :*,
    add: :*,
    rename: :*,
    embeds_many: :*,

    # vex
    validates: :*,

    # plug
    plug: :*,

    # phoenix
    action_fallback: :*,
    pipe_through: :*,
    forward: :*,
    get: :*,
    post: :*,
    patch: :*,
    put: :*,
    delete: :*,
    resources: :*,
    pipeline: :*,
    scope: :*,
    socket: :*,
    adapter: :*
  ]
]
