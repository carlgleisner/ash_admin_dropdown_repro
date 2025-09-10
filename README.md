# AshAdmin dropdown from relationship

## Running

```sh
mix deps.get
mix setup
```

## Description

This app has a domain `Tickets` where a resource `Representative` belongs to `Organization`. The resources are lifted from the `dev` application in the AshAdmin repo but have some parts commented out and new actions added with `alt_` as a prefix (will be important later). The `Representative` resoruce is backed by its own table instead of having a base filter on `users` as in the `dev` application.

## Reproduction

When creating a `Representative` with the default `:create` action, AshAdmin renders a fully working dropdown to select the representative's organization.

insert screenshot here

However, when creating `Representative` with the `:alt_create` action with an implementation that, to the best of my understanding, should be functionally equivalent to the default create action:

```elixir
create :alt_create do
    accept [:first_name, :last_name]

    argument :organization, :map

    change manage_relationship(:organization, type: :append)
end
```

no such dropdown is rendered by AshAdmin:

insert screenshot here

Looking at the `Organization` resource lifted from the `dev` application, its `:create` and `:update` actions are not default actions and the only difference to the implementation of the `:alt_create` and `:alt_update` actions for the `Representative` resource above - in which drop downs are not rendered - is that the `Organization` resource's actions take arguments that are `{:array, :map}` rather than `:map`.
