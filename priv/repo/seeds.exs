# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     MyApp.Repo.insert!(%MyApp.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

ash =
  MyApp.Tickets.create_organization!(%{
    name: "The Ash Project"
  })

_tags =
  MyApp.Tickets.create_tag!([
    %{name: "Marketing"},
    %{name: "Shipping"},
    %{name: "Legal"},
    %{name: "Accounts payable"},
    %{name: "Accounts receivable"}
  ])

_rep1 =
  MyApp.Tickets.alt_create_representative!(%{
    first_name: "John",
    last_name: "Doe",
    organization: ash,
    tag_names: ["Marketing"]
  })

_rep2 =
  MyApp.Tickets.alt_create_representative!(%{
    first_name: "Jane",
    last_name: "Doe",
    organization: ash,
    tag_names: ["Accounts payable", "Accounts receivable"]
  })
