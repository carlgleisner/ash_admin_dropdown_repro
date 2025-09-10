defmodule MyApp.Tickets.Representative do
  use Ash.Resource,
    domain: MyApp.Tickets,
    data_layer: AshPostgres.DataLayer,
    extensions: [
      AshAdmin.Resource
    ]

  admin do
    relationship_display_fields [:id, :first_name]
    label_field :full_name
  end

  postgres do
    repo MyApp.Repo
    table "representatives"
    # table "users"
    # base_filter_sql "representative = true"
  end

  # resource do
  #   base_filter representative: true
  # end

  actions do
    default_accept :*
    defaults [:create, :read, :update]

    # read :me do
    #   filter id: actor(:id)
    # end

    create :alt_create do
      accept [:first_name, :last_name]

      argument :organization, :map

      change manage_relationship(:organization, type: :append)
    end

    update :alt_update do
      primary? true
      require_atomic? false

      accept [:first_name, :last_name]

      argument :organization, :map

      change manage_relationship(:organization, type: :append_and_remove)
    end
  end

  # policies do
  #   bypass always() do
  #     authorize_if actor_attribute_equals(:admin, true)
  #   end

  #   policy action_type(:read) do
  #     authorize_if actor_attribute_equals(:representative, true)
  #     authorize_if relates_to_actor_via([:assigned_tickets, :reporter])
  #     authorize_if accessing_from(MyApp.Tickets.Organization, :representatives)
  #   end
  # end

  attributes do
    uuid_primary_key :id

    attribute :first_name, :string, public?: true
    attribute :last_name, :string, public?: true
    # attribute :representative, :boolean, public?: true
  end

  relationships do
    relationships do
      belongs_to :organization, MyApp.Tickets.Organization, public?: true
    end

    # has_many :assigned_tickets, MyApp.Tickets.Ticket do
    #   public? true
    #   destination_attribute :representative_id
    # end

    # has_many :comments, MyApp.Tickets.Comment do
    #   public? true
    #   relationship_context %{data_layer: %{table: "representative_comments"}}
    #   destination_attribute :resource_id
    # end
  end

  calculations do
    calculate :full_name, :string, concat([:first_name, :last_name], " ")
  end

  # aggregates do
  #   count :open_ticket_count, [:assigned_tickets], filter: [not: [status: "closed"]]
  # end

  identities do
    identity :representative_name, [:first_name, :last_name]
  end
end
