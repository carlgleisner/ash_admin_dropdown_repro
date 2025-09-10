defmodule MyApp.Tickets.Organization do
  use Ash.Resource,
    domain: MyApp.Tickets,
    data_layer: AshPostgres.DataLayer,
    extensions: [
      AshAdmin.Resource
    ]

  admin do
    label_field :name
    relationship_select_max_items 2
  end

  postgres do
    table "organizations"
    repo MyApp.Repo
  end

  actions do
    default_accept :*
    defaults [:read, :destroy]

    create :create do
      primary? true
      argument :representatives, {:array, :map}

      change manage_relationship(:representatives,
               type: :append
             )
    end

    update :update do
      primary? true
      require_atomic? false
      argument :representatives, {:array, :map}

      change manage_relationship(:representatives,
               type: :append_and_remove
             )
    end
  end

  attributes do
    uuid_primary_key :id

    attribute :name, :string, public?: true
  end

  relationships do
    # has_many :tickets, MyApp.Tickets.Ticket, public?: true
    has_many :representatives, MyApp.Tickets.Representative, public?: true
  end
end
