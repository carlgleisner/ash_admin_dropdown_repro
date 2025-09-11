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
      argument :tag_names, {:array, :string}

      change manage_relationship(:organization, type: :append)

      change manage_relationship(:tag_names, :tags,
               type: :append_and_remove,
               value_is_key: :name,
               on_lookup: :relate,
               on_no_match: :create
             )
    end

    update :alt_update do
      primary? true
      require_atomic? false

      accept [:first_name, :last_name]

      argument :organization, :map
      argument :tag_names, {:array, :string}

      change manage_relationship(:organization, type: :append_and_remove)

      change manage_relationship(:tag_names, :tags,
               type: :append_and_remove,
               value_is_key: :name,
               on_lookup: :relate,
               on_no_match: :create
             )
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

    attribute :first_name, :string do
      public? true
      allow_nil? false
    end

    attribute :last_name, :string do
      public? true
      allow_nil? false
    end

    # attribute :representative, :boolean, public?: true
  end

  relationships do
    relationships do
      belongs_to :organization, MyApp.Tickets.Organization, public?: true

      many_to_many :tags, MyApp.Tickets.Tag do
        through MyApp.Tickets.RepresentativeTag
        source_attribute_on_join_resource :representative_id
        destination_attribute_on_join_resource :tag_id
      end
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
