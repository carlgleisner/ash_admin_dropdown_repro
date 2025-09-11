defmodule MyApp.Tickets.Tag do
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
    table "tags"
    repo MyApp.Repo
  end

  actions do
    defaults [:read, :destroy, create: :*, update: :*]
  end

  attributes do
    uuid_primary_key :id
    attribute :name, :string, public?: true
  end

  relationships do
    many_to_many :representatives, MyApp.Tickets.Representative do
      through MyApp.Tickets.RepresentativeTag
      source_attribute_on_join_resource :tag_id
      destination_attribute_on_join_resource :representative_id
    end
  end
end
